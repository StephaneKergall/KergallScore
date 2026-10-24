#!/usr/bin/env python3
"""Assistant graphique de création de nouvelles partitions Lilypond pour KergallScore.

Génère un fichier .ly pré-rempli à partir des choix faits dans l'interface wxPython,
puis ouvre le résultat dans Frescobaldi.
"""
from __future__ import annotations

import re
import shutil
import subprocess
import unicodedata
from pathlib import Path
from typing import NamedTuple

import wx

# ------------------------------------------------------------------------
# Constantes
# ------------------------------------------------------------------------

PARTITIONS = Path(__file__).resolve().parent.parent
UTILS_DIR = PARTITIONS / ".utils"
COMPOSERS_FILE = UTILS_DIR / "composers.ily"
LILYPOND_LY_DIR = PARTITIONS / ".prog" / "lilypond-2.26.0" / "share" / "lilypond" / "2.26.0" / "ly"

NUMBERS = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
VOICES = {"S": "soprano", "A": "alto", "T": "tenor", "B": "bass", "H": "homme"}
PIANO_STAFFS = ["right", "left", "pedal"]
PIANO_STAFFS_FR = ["Main droite", "Main gauche", "Pédalier"]

# Champs pouvant contenir un nom choisi via le sélecteur de compositeur.
PICKER_FIELDS = ("composer", "poet", "arranger")

# Catégories numérotées à ne pas proposer dans le sélecteur (grégorien, assemblages, commandes).
EXCLUDED_CATEGORY_PREFIXES = ("08", "09", "99")

# Largeurs des contrôles de l'onglet « Titres et en-têtes ».
FIELD_LABEL_WIDTH = 145
ENTRY_WIDTH = 260

# couleurs des boutons et du texte
REMOVE_BUTTON_COLOUR = "#E57373"
REMOVE_BUTTON_HOVER_COLOUR = "#EF9A9A"
MUTED_BUTTON_COLOUR = "#8a8a8a"
MUTED_BUTTON_HOVER_COLOUR = "#6a6a6a"
DISABLED_BUTTON_COLOUR = "#4a4a4a"
DISABLED_TEXT_COLOUR = "#8a8a8a"

_COMPOSER_LINE_RE = re.compile(r'^\s*([^\s=]+)\s*=\s*"(.*)"\s*(?:%.*)?$')
_INVALID_FILENAME_CHARS = set('/\\:*?"<>|')
_WINDOWS_RESERVED_NAMES = {"CON", "PRN", "AUX", "NUL"} | {
    f"{prefix}{index}" for prefix in ("COM", "LPT") for index in range(1, 10)
}
_TRANSLITERATION = str.maketrans({
    "ø": "o", "Ø": "O", "æ": "ae", "Æ": "AE", "œ": "oe", "Œ": "OE",
    "ß": "ss", "đ": "d", "Đ": "D", "ł": "l", "Ł": "L", "þ": "th", "Þ": "Th",
    "ð": "d", "Ð": "D",
})
_KEY_RE = re.compile(r"[a-g](?:is|es)?")
_TIME_RE = re.compile(r"\d+/\d+")
_PARTIAL_RE = re.compile(r"\d+\.?")
_SCHEMA_RE = re.compile(r"[SATBH]+(?:-[SATBH]+)*")


class GenerationError(Exception):
    """Erreur de saisie empêchant la génération d'un fichier .ly valide."""


# ------------------------------------------------------------------------
# Petits utilitaires
# ------------------------------------------------------------------------

def _set_button_colours(button, normal: str, hover: str, foreground: str = "#FFFFFF"):
    """Applique les couleurs à un bouton natif wx, sans remplacer son rendu système."""
    button.SetBackgroundColour(wx.Colour(normal))
    button.SetForegroundColour(wx.Colour(foreground))

    def set_hover(_event):
        button.SetBackgroundColour(wx.Colour(hover))
        button.Refresh()

    def set_normal(_event):
        button.SetBackgroundColour(wx.Colour(normal))
        button.Refresh()

    button.Bind(wx.EVT_ENTER_WINDOW, set_hover)
    button.Bind(wx.EVT_LEAVE_WINDOW, set_normal)


def _use_system_button_colours(button):
    """Restaure la palette native wx pour suivre le thème du système."""
    button.SetBackgroundColour(wx.NullColour)
    button.SetForegroundColour(wx.NullColour)
    button.Refresh()


def _disable_button(button):
    button.Disable()
    button.SetBackgroundColour(wx.Colour(DISABLED_BUTTON_COLOUR))
    button.SetForegroundColour(wx.Colour(DISABLED_TEXT_COLOUR))
    button.Refresh()


def _enable_button(button):
    button.Enable()
    button.SetBackgroundColour(wx.NullColour)
    button.SetForegroundColour(wx.NullColour)
    button.Refresh()


def ly_string(value: str) -> str:
    """Chaîne Lilypond littérale, avec guillemets et antislashs échappés."""
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def composer_surname(name: str) -> str:
    """Nom de famille (dernier mot avant les dates entre parenthèses), en minuscules."""
    before_paren = name.split("(")[0].strip()
    words = before_paren.split()
    return words[-1].lower() if words else before_paren.lower()


def composer_initial(name: str) -> str:
    """Initiale ASCII du nom de famille (``É`` -> ``E``) ; vide si le nom n'en a pas."""
    surname = composer_surname(name)
    if not surname:
        return ""
    normalized = unicodedata.normalize("NFKD", surname).translate(_TRANSLITERATION)
    ascii_surname = normalized.encode("ascii", "ignore").decode("ascii")
    first = ascii_surname[:1]
    return first.upper() if first.isalpha() else ""


def load_composers() -> dict[str, str]:
    """Associe chaque identifiant Lilypond (ex: ``\\bach``) au nom affiché du compositeur."""
    if not COMPOSERS_FILE.is_file():
        return {}
    try:
        content = COMPOSERS_FILE.read_text(encoding="utf-8")
    except OSError:
        return {}
    composers: dict[str, str] = {}
    for line in content.splitlines():
        if line.lstrip().startswith("%"):
            continue
        match = _COMPOSER_LINE_RE.match(line)
        if match:
            name = re.sub(r"\\(.)", r"\1", match.group(2))
            composers["\\" + match.group(1)] = name
    return composers


def sync_utils_to_lilypond() -> bool:
    """Recopie ``.utils/*.ily`` dans l'installation Lilypond locale (cf. tâche « Synchroniser .utils/ »)."""
    if not LILYPOND_LY_DIR.is_dir():
        return False
    try:
        for source in UTILS_DIR.glob("*.ily"):
            shutil.copy2(source, LILYPOND_LY_DIR / source.name)
    except OSError:
        return False
    return True


def _safe_filename_part(text: str) -> str:
    """Retire d'un nom suggéré les caractères interdits dans un nom de dossier."""
    cleaned = "".join(
        "-" if char in _INVALID_FILENAME_CHARS or ord(char) < 32 else char
        for char in text
    )
    return re.sub(r"\s+", " ", cleaned).strip(" .")


def validate_file_stem(stem: str) -> None:
    """Vérifie qu'un nom de dossier peut être créé sur le système de fichiers."""
    if not stem:
        raise GenerationError("Le nom du dossier est vide.")
    if stem in (".", "..") or stem.startswith("."):
        raise GenerationError("Le nom du dossier ne peut pas commencer par un point.")
    if stem != stem.rstrip(". "):
        raise GenerationError("Le nom du dossier ne peut pas se terminer par un point ou une espace.")
    if stem.split(".")[0].upper() in _WINDOWS_RESERVED_NAMES:
        raise GenerationError(f"« {stem} » est un nom réservé par Windows.")
    invalid = sorted({char for char in stem if char in _INVALID_FILENAME_CHARS or ord(char) < 32})
    if invalid:
        shown = ", ".join(repr(char) for char in invalid)
        raise GenerationError(f"Le nom du dossier contient des caractères interdits : {shown}.")


def validate_choir_schema(schema: str) -> None:
    """Vérifie qu'un schéma de chœur (ex: ``SA-TB``) est exploitable."""
    if not _SCHEMA_RE.fullmatch(schema):
        raise GenerationError(
            f"Schéma de chœur invalide : « {schema} ». Utilisez par exemple SA-TB."
        )
    if len(schema.replace("-", "")) > len(NUMBERS):
        raise GenerationError(f"Le chœur ne peut pas dépasser {len(NUMBERS)} voix.")
    if any(len(group) > 4 for group in schema.split("-")):
        raise GenerationError("Une portée ne peut pas contenir plus de 4 voix superposées.")


class MusicSettings(NamedTuple):
    """Réglages communs du bloc ``global``."""
    key: str
    time_signature: str
    partial: str
    tempo_text: str
    midi_tempo: int


# ==============================================================================
# Génération du code Lilypond (fonctions pures, sans dépendance à l'interface)
# ==============================================================================

def generic_var(identifier: str, expression: str, content: str = "") -> str:
    """Bloc Lilypond générique : ``identifiant = expression { contenu }``."""
    if content and not content.endswith("\n"):
        content += "\n"
    return f"{identifier} = {expression} {{\n{content}}}\n\n"


def music_var(identifier: str, fixed: bool, high: bool, global_var: str) -> str:
    """Déclare une variable musicale (voix ou main d'instrument) basée sur ``global_var``."""
    mode = "\\fixed" if fixed else "\\relative"
    octave = "'" if high else ""
    return generic_var(identifier, f"{mode} c{octave}", f"  \\{global_var}\n")


def lyric_var(identifier: str, verse_number: int | None = None) -> str:
    """Déclare une variable de paroles (``\\lyricmode``), numérotée si ``verse_number`` est fourni."""
    prefix = ""
    if verse_number:
        alternate_side = " ##t" if verse_number % 2 == 0 else " ##f"
        prefix = f"\\strophemode {verse_number}{alternate_side} "
    return generic_var(identifier, f"{prefix}\\lyricmode")


def _verse_number(verse_index: int, verse_count: int) -> int | None:
    """Numéro de couplet pour ``\\strophemode`` (aucun s'il n'y a qu'un couplet)."""
    return verse_index + 1 if verse_count > 1 else None


# ---- Chœur ---------------------------------------------------------------

def voice_name(index: int, schema: str) -> str:
    """Nom de variable pour la voix à la position ``index`` du ``schema`` (ex: ``"SATB"``).

    Si plusieurs voix partagent la même lettre (ex: deux sopranes), un suffixe
    ``One``/``Two``/... est ajouté pour les distinguer.
    """
    voice = schema[index]
    if schema.count(voice) > 1:
        occurrence = schema[:index + 1].count(voice)
        return VOICES[voice] + NUMBERS[occurrence - 1]
    return VOICES[voice]


def lyric_name(voice_var: str, verse_index: int) -> str:
    """Nom de variable pour un couplet de paroles (ex: ``sopranoVerseOne``)."""
    return f"{voice_var}Verse{NUMBERS[verse_index]}"


def voice_block(voice_var: str, staff_voice_index: int | None) -> str:
    """Ligne ``\\new Voice`` référençant la variable musicale correspondante.

    ``staff_voice_index`` est le rang de la voix dans sa portée (0, 1, ...) quand
    plusieurs voix partagent une même portée (ex: 2 voix d'hommes), sinon ``None``.
    """
    prefix = " " if staff_voice_index is None else "    "
    voice_override = f"\\voice{NUMBERS[staff_voice_index]} " if staff_voice_index is not None else ""
    return f'{prefix}\\new Voice = "{voice_var}" {{{voice_override}\\{voice_var} }}\n'


def lyrics_block(voice_var: str, variable_name: str) -> str:
    """Bloc ``\\new Lyrics`` rattachant un couplet à sa voix."""
    return (
        "  \\new Lyrics \\with {\n"
        "    \\override VerticalAxisGroup.staff-affinity = #CENTER\n"
        "  }"
        f' \\lyricsto "{voice_var}" \\{variable_name}\n'
    )


def choir_vars(schema: str, verse_count: int, shared_lyrics: bool) -> str:
    """Déclare les variables musicales et les couplets de paroles du chœur."""
    voices = schema.replace("-", "")
    parts: list[str] = []
    for index, letter in enumerate(voices):
        name = voice_name(index, voices)
        parts.append(music_var(name, letter in "AB", letter in "SA", "global"))
        if not shared_lyrics:
            for verse_index in range(verse_count):
                parts.append(
                    lyric_var(lyric_name(name, verse_index), _verse_number(verse_index, verse_count))
                )
        parts.append("\n")
    if shared_lyrics:
        for verse_index in range(verse_count):
            parts.append(
                lyric_var(f"Verse{NUMBERS[verse_index]}", _verse_number(verse_index, verse_count))
            )
    parts.append("\n")
    return "".join(parts)


def _choir_lyrics(
    staff_groups: list[str],
    group_index: int,
    group: str,
    voices: str,
    first_voice_index: int,
    verse_count: int,
    shared_lyrics: bool,
) -> str:
    """Lignes ``\\new Lyrics`` d'une portée du chœur."""
    if shared_lyrics:
        # Paroles communes : une seule ligne par portée, sauf pour un chœur à deux
        # portées où elles sont traditionnellement placées entre les deux.
        if len(staff_groups) > 2 or group_index == 0:
            voice_var = voice_name(first_voice_index, voices)
            blocks = [
                lyrics_block(voice_var, f"Verse{NUMBERS[verse_index]}")
                for verse_index in range(verse_count)
            ]
            return "".join(blocks) + "\n"
        return ""

    # Paroles distinctes : chaque voix reçoit ses propres couplets.
    blocks = []
    for offset in range(len(group)):
        voice_var = voice_name(first_voice_index + offset, voices)
        for verse_index in range(verse_count):
            blocks.append(lyrics_block(voice_var, lyric_name(voice_var, verse_index)))
    return "".join(blocks) + "\n"


def choir_staff(schema: str, verse_count: int, shared_lyrics: bool) -> str:
    """Bloc ``ChoeurPart`` : une portée par groupe de voix du ``schema`` (ex: ``"SA-TB"``)."""
    staff_groups = schema.split("-")
    voices = schema.replace("-", "")
    show_instrument_names = any(len(group) != 2 for group in staff_groups)
    text = (
        "ChoeurPart = \\new ChoirStaff \\with {\n"
        '\tmidiInstrument = "choir aahs"\n'
        "} <<\n"
    )

    first_voice_index = 0
    for group_index, group in enumerate(staff_groups):
        is_polyphonic = len(group) > 1
        text += "  \\new Staff \\with {\n"
        if show_instrument_names:
            if is_polyphonic:
                names = " ".join(ly_string(f"{letter}.") for letter in group)
                text += f"    instrumentName = \\markup \\center-column {{ {names} }}\n"
            else:
                text += f"    instrumentName = {ly_string(group + '.')}\n"
        if is_polyphonic:
            text += "    \\consists Merge_rests_engraver\n"
        else:
            text += '    \\consists "Ambitus_engraver"\n'
        if "B" in group or "H" in group:
            text += "    \\clef bass\n"
        elif all(letter == "T" for letter in group):
            text += '    \\clef "treble_8"\n'

        text += "  } "
        if is_polyphonic:
            text += "<<\n"
            for offset in range(len(group)):
                text += voice_block(voice_name(first_voice_index + offset, voices), offset)
            text += "  >>\n"
        else:
            text += voice_block(voice_name(first_voice_index, voices), None)

        text += _choir_lyrics(
            staff_groups, group_index, group, voices, first_voice_index,
            verse_count, shared_lyrics,
        )
        first_voice_index += len(group)

    return text + ">>\n\n"


def choir_pack(schema: str, verse_count: int, shared_lyrics: bool) -> str:
    """Assemble variables + portées pour la partie « Choeur »."""
    schema = schema.strip().upper()
    validate_choir_schema(schema)
    if not 1 <= verse_count <= len(NUMBERS):
        raise GenerationError(f"Le nombre de couplets doit être compris entre 1 et {len(NUMBERS)}.")
    return choir_vars(schema, verse_count, shared_lyrics) + choir_staff(schema, verse_count, shared_lyrics)


# ---- Clavier (piano ou orgue) ---------------------------------------------

def piano_part_name(staff_index: int, voice_index: int | None = None) -> str:
    """Nom de variable pour une main de clavier, numérotée si plusieurs voix s'y superposent."""
    return PIANO_STAFFS[staff_index] + (NUMBERS[voice_index] if voice_index is not None else "")


def piano_vars(staffs: list[int]) -> str:
    """Déclare les variables musicales de chaque main (et voix superposées) du clavier."""
    parts: list[str] = []
    for staff_index, voice_count in enumerate(staffs):
        if voice_count == 0:
            continue
        high = staff_index == 0
        if voice_count == 1:
            parts.append(music_var(piano_part_name(staff_index), False, high, "global"))
        else:
            for voice_index in range(voice_count):
                parts.append(
                    music_var(piano_part_name(staff_index, voice_index), False, high, "global")
                )
    return "".join(parts)


def piano_staff(staffs: list[int]) -> str:
    """Bloc ``ClavierPart`` : un ``PianoStaff`` à 2 portées (piano) ou 3 (orgue + pédalier)."""
    is_organ = len(staffs) == 3
    text = (
        "ClavierPart = \\new PianoStaff \\with {\n"
        f'\tinstrumentName = "{"Org" if is_organ else "Pian"}."\n'
        f'\tmidiInstrument = "{"church organ" if is_organ else "acoustic grand"}"\n'
    )
    if is_organ:
        text += "\tmidiMinimumVolume = #0.1\n\tmidiMaximumVolume = #0.3\n"
    text += "} <<\n"

    for staff_index, voice_count in enumerate(staffs):
        if voice_count == 0:
            continue
        clef = "\\clef bass " if staff_index > 0 else ""
        text += f'  \\new Staff = "{PIANO_STAFFS[staff_index]}" {{ {clef}'
        if voice_count == 1:
            text += f"\\{piano_part_name(staff_index)} }}\n"
        else:
            voices = " \\\\ ".join(
                f"\\{piano_part_name(staff_index, voice_index)}"
                for voice_index in range(voice_count)
            )
            text += f"<< {voices} >> }}\n"

    return text + ">>\n\n"


def clavier_pack(voice_counts: list[int], is_organ: bool) -> str:
    """Assemble variables + portées du clavier (piano : 2 mains, orgue : 3 avec pédalier)."""
    staffs = list(voice_counts[:3 if is_organ else 2])
    if not any(staffs):
        raise GenerationError("Le clavier doit comporter au moins une portée avec une voix.")
    for count in staffs:
        if not 0 <= count <= len(NUMBERS):
            raise GenerationError(f"Chaque portée doit avoir entre 0 et {len(NUMBERS)} voix.")
    return piano_vars(staffs) + piano_staff(staffs)


# ---- Solo ------------------------------------------------------------------

def solo_vars(verse_count: int) -> str:
    """Déclare la voix soliste et ses couplets de paroles numérotés."""
    text = music_var("soloVoice", True, True, "global")
    for verse_index in range(verse_count):
        text += lyric_var(
            f"soloVerse{NUMBERS[verse_index]}",
            _verse_number(verse_index, verse_count),
        )
    return text


def solo_staff(verse_count: int) -> str:
    """Bloc ``SoloPart`` : une portée de soliste avec ses couplets."""
    lines = [
        "SoloPart = \\new Staff \\with {",
        '\tinstrumentName = "Solo"',
        '\tshortInstrumentName = "Sl."',
        '\tmidiInstrument = "choir aahs"',
        '  \\consists "Ambitus_engraver"',
        "} <<",
        '  \\new Voice = "solo" { \\soloVoice }',
    ]
    for verse_index in range(verse_count):
        lines.append(f'  \\new Lyrics \\lyricsto "solo" \\soloVerse{NUMBERS[verse_index]}')
    lines.append(">>")
    return "\n".join(lines) + "\n\n"


def solo_pack(verse_count: int) -> str:
    """Assemble variables + portée du solo."""
    if not 1 <= verse_count <= len(NUMBERS):
        raise GenerationError(f"Le nombre de couplets doit être compris entre 1 et {len(NUMBERS)}.")
    return solo_vars(verse_count) + solo_staff(verse_count)


# ---- Flûte -----------------------------------------------------------------

def flute_vars(has_lyrics: bool) -> str:
    """Déclare la voix de flûte et, si besoin, sa seule ligne de paroles."""
    text = music_var("flute", True, True, "global")
    if has_lyrics:
        text += lyric_var("fluteVerse")
    return text


def flute_staff(has_lyrics: bool) -> str:
    """Bloc ``FlûtePart`` : une portée de flûte, avec paroles optionnelles."""
    if has_lyrics:
        return (
            "FlûtePart = \\new Staff \\with {\n"
            '\tinstrumentName = "Flûte"\n'
            '\tshortInstrumentName = "Fl."\n'
            '\tmidiInstrument = "flute"\n'
            "} <<\n"
            '  \\new Voice = "flute" { \\flute }\n'
            '  \\new Lyrics \\lyricsto "flute" \\fluteVerse\n'
            ">>\n\n"
        )
    return (
        "FlûtePart = \\new Staff \\with {\n"
        '\tinstrumentName = "Flûte"\n'
        '\tshortInstrumentName = "Fl."\n'
        '\tmidiInstrument = "flute"\n'
        "} \\flute\n\n"
    )


def flute_pack(has_lyrics: bool) -> str:
    """Assemble variable + portée de la flûte."""
    return flute_vars(has_lyrics) + flute_staff(has_lyrics)


# ==============================================================================
# Assemblage du document .ly
# ==============================================================================

def build_global_block(settings: MusicSettings) -> str:
    """Bloc ``global`` : réglages communs (armure, mesure, anacrouse, tempo textuel)."""
    lines = [
        '\\version "2.26.0"',
        '\\include "settings.ily"',
        '\\include "composers.ily"',
        "",
        "global = {",
        "  \\autoBeamOff",
        "  \\mergeDifferentlyHeadedOn",
        "  \\mergeDifferentlyDottedOn",
        f"  \\key {settings.key} \\major",
        f"  \\time {settings.time_signature}",
    ]
    if settings.partial:
        lines.append(f"  \\partial {settings.partial}")
    if settings.tempo_text:
        lines.append(f"  \\tempo {ly_string(settings.tempo_text)}")
    lines.append("}")
    return "\n".join(lines) + "\n\n"


def _header_field_value(key: str, value: str) -> str:
    """Valeur Lilypond d'un champ de ``\\header`` (citation ou texte littéral)."""
    if key in PICKER_FIELDS and value.startswith("\\"):
        if not value[1:].isidentifier():
            raise GenerationError(f"Identifiant invalide pour « {key} » : {value}")
        if key == "poet":
            return f'\\markup {{"Paroles :" {value}}}'
        if key == "arranger":
            return f'\\markup {{"Harmonisation :" {value}}}'
        return value
    if key == "title":
        value = value.upper()
    return ly_string(value)


def build_header_fields(values: dict[str, str]) -> str:
    """Lignes du bloc ``\\header`` : citations (compositeur/parolier/arrangeur) ou texte brut."""
    lines = [
        f"    {key} = {_header_field_value(key, value)}"
        for key, value in values.items()
        if value
    ]
    return "\n".join(lines) + ("\n" if lines else "")


def build_toc_line(
    title: str,
    composer: str,
    composers: dict[str, str] | None = None,
) -> str:
    """Ligne de table des matières (``\\tocItem...``), si un titre est renseigné."""
    if not title:
        return ""
    if composer:
        if composer.startswith("\\"):
            display_name = (composers or {}).get(composer)
            if display_name:
                composer = composer_surname(display_name).title()
            else:
                composer = composer[1:].title()
        return f"\\tocItemComposer {ly_string(title)} {ly_string(composer)}\n"
    return f"\\tocItem \\markup {ly_string(title)}\n"


def build_instruments_reference(parts: dict[str, str]) -> str:
    """Référence les ``...Part`` déclarés : seul, ou combinés dans un ``<< >>``."""
    if len(parts) == 1:
        name = next(iter(parts))
        return f"  \\{name}Part\n"
    lines = "".join(f"    \\{name}Part\n" for name in parts)
    return f"  <<\n{lines}  >>\n"


def build_score_block(header_values: dict[str, str], parts: dict[str, str], midi_tempo: int) -> str:
    """Bloc ``\\score`` complet : en-tête, portées, mise en page et MIDI."""
    return (
        "\\score {\n"
        "  \\header {\n"
        + build_header_fields(header_values)
        + "  }\n"
        + build_instruments_reference(parts)
        + "  \\layout {\\context{\\Staff \\RemoveAllEmptyStaves }}\n"
        + f"  \\midi {{\\tempo 4={midi_tempo} }}\n"
        + "}\n"
    )


def build_document(
    settings: MusicSettings,
    header_values: dict[str, str],
    parts: dict[str, str],
    composers: dict[str, str] | None = None,
) -> str:
    """Document Lilypond complet, prêt à être écrit dans un fichier .ly."""
    if not parts:
        raise GenerationError("Sélectionnez au moins une partie.")
    return (
        build_global_block(settings)
        + "".join(parts.values())
        + build_toc_line(
            header_values.get("title", ""),
            header_values.get("composer", ""),
            composers,
        )
        + build_score_block(header_values, parts, settings.midi_tempo)
    )


# ==============================================================================
# Interface graphique
# ==============================================================================

class HeaderTab(wx.Panel):
    """Onglet « Titres et en-têtes » : champs du \\header, catégorie et sélecteur de compositeur."""

    def __init__(self, master):
        super().__init__(master)
        self.filename_modified = False
        self.root_sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.left_scroll = wx.ScrolledWindow(self, style=wx.VSCROLL)
        self.left_scroll.SetInitialSize((ENTRY_WIDTH + FIELD_LABEL_WIDTH, 300))
        self.left_scroll.SetScrollRate(0, 12)
        self.left_sizer = wx.BoxSizer(wx.VERTICAL)
        self.left_scroll.SetSizer(self.left_sizer)
        self.fields_sizer = wx.BoxSizer(wx.VERTICAL)
        self.left_sizer.Add(self.fields_sizer, 0, wx.EXPAND)
        self.root_sizer.Add(self.left_scroll, 1, wx.EXPAND | wx.ALL, 8)
        self.SetSizer(self.root_sizer)

        # "title" et "composer" sont toujours affichés ; les autres sont ajoutés à la demande
        # via le menu "+" et retirés avec leur bouton "-".
        self.fields = {
            "dedication":  "Dédicace",
            "title":       "Titre",
            "subtitle":    "Sous-titre",
            "subsubtitle": "Sous-sous-titre",
            "instrument":  "Instrument",
            "composer":    "Compositeur",
            "poet":        "Paroles",
            "meter":       "Mètre",
            "arranger":    "Arrangeur",
            "copyright":   "Copyrights (1ère page)",
            "tagline":     "Slogan (dernière page)",
        }
        self._field_order = {key: index for index, key in enumerate(self.fields)}
        self._field_keys_by_label = {}
        self.available_fields: list[str] = []

        for key, label in list(self.fields.items()):
            self._field_keys_by_label[label] = key
            frame = wx.Panel(self.left_scroll)
            row_sizer = wx.BoxSizer(wx.HORIZONTAL)
            frame.SetSizer(row_sizer)
            row_sizer.Add(
                wx.StaticText(frame, label=label, size=(FIELD_LABEL_WIDTH, -1)),
                0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5,
            )
            entry = wx.TextCtrl(frame, size=(ENTRY_WIDTH, -1))
            row_sizer.Add(entry, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 8)
            if key in PICKER_FIELDS:
                entry.Bind(wx.EVT_SET_FOCUS, lambda _event, k=key: self._set_picker_target(k))
            remove = wx.Button(frame, label="-", size=(42, -1))
            _set_button_colours(remove, REMOVE_BUTTON_COLOUR, REMOVE_BUTTON_HOVER_COLOUR)
            remove.Bind(wx.EVT_BUTTON, lambda _event, k=key: self.remove_field(k))
            row_sizer.Add(remove, 0, wx.ALIGN_CENTER_VERTICAL)
            self.fields[key] = {"name": label, "entry": entry, "frame": frame}

            if key in ("title", "composer"):
                self.fields_sizer.Add(frame, 0, wx.EXPAND | wx.BOTTOM, 5)
            else:
                frame.Hide()
                self.available_fields.append(key)

        choices = ["+"] + [self.fields[key]["name"] for key in self.available_fields]
        self.add_field_menu = wx.Choice(self.left_scroll, choices=choices)
        self.add_field_menu.SetSelection(0)
        self.add_field_menu.Bind(wx.EVT_CHOICE, self._on_optional_field_choice)
        self.left_sizer.Add(self.add_field_menu, 0, wx.ALL, 8)

        self.left_sizer.Add(wx.StaticText(self.left_scroll, label="Catégorie"), 0, wx.LEFT | wx.TOP, 8)
        self.categories = self._get_categories() or ["13-Autres"]
        self.category_radio = wx.RadioBox(
            self.left_scroll, label="", choices=[cat[3:] for cat in self.categories],
            majorDimension=1, style=wx.RA_SPECIFY_COLS,
        )
        self.category_radio.SetSelection(0)
        self.left_sizer.Add(self.category_radio, 0, wx.EXPAND | wx.ALL, 5)

        filename_frame = wx.Panel(self.left_scroll)
        filename_sizer = wx.BoxSizer(wx.HORIZONTAL)
        filename_frame.SetSizer(filename_sizer)
        filename_sizer.Add(
            wx.StaticText(filename_frame, label="Nom du dossier", size=(FIELD_LABEL_WIDTH, -1)),
            0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5,
        )
        self.filename_entry = wx.TextCtrl(filename_frame, size=(ENTRY_WIDTH, -1))
        filename_sizer.Add(self.filename_entry, 0, wx.ALIGN_CENTER_VERTICAL)
        self.left_sizer.Add(filename_frame, 0, wx.EXPAND | wx.ALL, 5)
        self.filename_entry.Bind(wx.EVT_TEXT, self.on_filename_edit)
        self.fields["title"]["entry"].Bind(wx.EVT_TEXT, self.on_title_or_composer_change)
        self.fields["composer"]["entry"].Bind(wx.EVT_TEXT, self.on_title_or_composer_change)

        self.build_composer_picker()
        wx.CallAfter(self._update_scrolling)

    # ------------------------------------------------------------------
    # Défilement du panneau de gauche
    # ------------------------------------------------------------------

    def _update_scrolling(self):
        """Recalcule la taille virtuelle après un ajout/retrait de champ."""
        self.left_scroll.Layout()
        self.left_scroll.FitInside()

    def _on_optional_field_choice(self, event):
        if event.GetSelection() > 0:
            self.on_optional_field_selected(event.GetString())
        self.add_field_menu.SetSelection(0)

    # ------------------------------------------------------------------
    # Sélecteur de compositeur (recherche par initiale du nom de famille)
    # ------------------------------------------------------------------

    def build_composer_picker(self):
        """Construit le panneau de sélection (lettres A-Z + résultats + bouton « Nouveau nom »)."""
        self.picker_frame = wx.Panel(self)
        picker_sizer = wx.BoxSizer(wx.VERTICAL)
        self.picker_frame.SetSizer(picker_sizer)
        self.picker_target = "composer"

        letters_frame = wx.Panel(self.picker_frame)
        letters_sizer = wx.GridSizer(0, 6, 2, 5)
        letters_frame.SetSizer(letters_sizer)
        self.letter_buttons: dict[str, wx.Button] = {}
        for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
            button = wx.Button(letters_frame, label=letter, size=(34, 28))
            button.Bind(
                wx.EVT_BUTTON,
                lambda _event, selected=letter: self.show_composers_for_letter(selected),
            )
            letters_sizer.Add(button, 0)
            self.letter_buttons[letter] = button
        picker_sizer.Add(letters_frame, 0, wx.EXPAND)

        self.composer_results = wx.Panel(self.picker_frame)
        self.results_sizer = wx.BoxSizer(wx.VERTICAL)
        self.composer_results.SetSizer(self.results_sizer)
        picker_sizer.Add(self.composer_results, 0, wx.EXPAND | wx.TOP, 10)

        new_composer = wx.Button(self.picker_frame, label="Nouveau nom")
        new_composer.Bind(wx.EVT_BUTTON, lambda _event: self.open_new_composer_popup())
        picker_sizer.Add(new_composer, 0, wx.TOP, 8)
        self.root_sizer.Add(self.picker_frame, 0, wx.ALL | wx.EXPAND, 12)

        self.refresh_composers()
        self.show_composer_picker()

    def show_composer_picker(self):
        """Affiche le panneau de sélection s'il n'est pas déjà visible."""
        if not self.picker_frame.IsShown():
            self.picker_frame.Show()
            self.Layout()
            self._update_scrolling()

    def _set_picker_target(self, key):
        """Définit quel champ (compositeur/parolier/arrangeur) reçoit le prochain choix."""
        self.picker_target = key

    def _active_picker_fields(self):
        """Champs du sélecteur actuellement affichés."""
        return [key for key in PICKER_FIELDS if self.fields[key]["frame"].IsShown()]

    def show_composers_for_letter(self, letter):
        """Liste les noms dont le nom de famille commence par ``letter``."""
        self.results_sizer.Clear(delete_windows=True)

        matches = [
            (key, name)
            for key, name, _surname, initial in self.composer_entries
            if initial == letter
        ]

        self.picker_frame.Freeze()
        try:
            if not matches:
                self.results_sizer.Add(
                    wx.StaticText(self.composer_results, label="Aucun nom"), 0, wx.ALL, 2,
                )
            else:
                for key, name in matches:
                    button = wx.Button(
                        self.composer_results, label=name.replace("&", "&&"), size=(240, -1),
                    )
                    button.SetToolTip(name)
                    _use_system_button_colours(button)
                    button.Bind(
                        wx.EVT_BUTTON,
                        lambda _event, selected=key: self._select_composer(selected),
                    )
                    self.results_sizer.Add(button, 0, wx.ALL, 2)
            self.results_sizer.Layout()
            self.composer_results.Layout()
        finally:
            self.picker_frame.Thaw()
        self.Layout()
        self._update_scrolling()

    def _select_composer(self, key):
        """Place l'identifiant choisi dans le champ actuellement ciblé."""
        entry = self.fields[self.picker_target]["entry"]
        entry.SetValue(key)
        entry.SetInsertionPointEnd()
        if self.picker_target == "composer":
            self.on_title_or_composer_change()

    def open_new_composer_popup(self):
        """Popup de saisie d'un nouveau compositeur/parolier/arrangeur."""
        popup = wx.Dialog(self, title="Nouveau nom")
        popup_sizer = wx.BoxSizer(wx.VERTICAL)
        fields = {}
        for key, label in (("identifiant", "Identifiant"), ("nom", "Nom et date")):
            row = wx.BoxSizer(wx.HORIZONTAL)
            row.Add(
                wx.StaticText(popup, label=label, size=(105, -1)),
                0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5,
            )
            fields[key] = wx.TextCtrl(popup, size=(240, -1))
            row.Add(fields[key], 1)
            popup_sizer.Add(row, 0, wx.EXPAND | wx.ALL, 8)
        buttons = wx.StdDialogButtonSizer()
        save = wx.Button(popup, wx.ID_SAVE, "Enregistrer")
        _use_system_button_colours(save)
        cancel = wx.Button(popup, wx.ID_CANCEL, "Annuler")
        _set_button_colours(cancel, MUTED_BUTTON_COLOUR, MUTED_BUTTON_HOVER_COLOUR)
        buttons.AddButton(save)
        buttons.AddButton(cancel)
        buttons.Realize()
        popup_sizer.Add(buttons, 0, wx.EXPAND | wx.ALL, 8)
        popup.SetSizerAndFit(popup_sizer)
        save.Bind(
            wx.EVT_BUTTON,
            lambda _event: self.save_new_composer(
                fields["identifiant"].GetValue().strip(),
                fields["nom"].GetValue().strip(),
                popup,
            ),
        )
        popup.SetEscapeId(wx.ID_CANCEL)
        save.SetDefault()
        wx.CallAfter(fields["identifiant"].SetFocus)
        popup.ShowModal()
        popup.Destroy()

    def save_new_composer(self, identifiant: str, nom: str, popup):
        """Ajoute le nom dans composers.ily, synchronise Lilypond et rafraîchit le sélecteur."""
        identifiant = identifiant.lstrip("\\").strip()
        nom = nom.strip()
        if not identifiant or not nom:
            wx.MessageBox(
                "Renseignez l'identifiant et le nom.", "Nouveau nom",
                wx.OK | wx.ICON_WARNING, popup,
            )
            return
        if not identifiant.isidentifier():
            wx.MessageBox(
                "L'identifiant doit être un identifiant Lilypond valide : lettres, "
                "chiffres et « _ », sans espace ni tiret.",
                "Identifiant invalide", wx.OK | wx.ICON_WARNING, popup,
            )
            return
        if "\\" + identifiant in load_composers():
            wx.MessageBox(
                f"Le nom « \\{identifiant} » existe déjà dans composers.ily.",
                "Nom en double", wx.OK | wx.ICON_WARNING, popup,
            )
            return
        initial = composer_initial(nom)
        if not initial:
            wx.MessageBox(
                "Le nom doit contenir un nom de famille commençant par une lettre.",
                "Nom invalide", wx.OK | wx.ICON_WARNING, popup,
            )
            return

        try:
            if COMPOSERS_FILE.is_file():
                content = COMPOSERS_FILE.read_text(encoding="utf-8")
            else:
                content = '\\version "2.26.0"\n\n'
            if content and not content.endswith("\n"):
                content += "\n"
            COMPOSERS_FILE.write_text(
                content + f"{identifiant} = {ly_string(nom)}\n", encoding="utf-8",
            )
        except OSError as error:
            wx.MessageBox(
                f"Impossible d'écrire dans « {COMPOSERS_FILE} » :\n{error}",
                "Erreur d'écriture", wx.OK | wx.ICON_ERROR, popup,
            )
            return

        if not sync_utils_to_lilypond():
            wx.MessageBox(
                "Le nom a été ajouté, mais la copie vers l'installation Lilypond "
                "a échoué. Lancez la tâche « Synchroniser .utils/ ».",
                "Synchronisation incomplète", wx.OK | wx.ICON_WARNING, popup,
            )

        self.refresh_composers()
        popup.EndModal(wx.ID_OK)
        if initial in self.letter_buttons:
            wx.CallAfter(self.show_composers_for_letter, initial)

    def refresh_composers(self):
        """Recharge composers.ily et met à jour l'état (actif/inactif) des lettres A-Z."""
        self.composers = load_composers()
        self.composer_entries = sorted(
            (
                (key, name, composer_surname(name), composer_initial(name))
                for key, name in self.composers.items()
            ),
            key=lambda entry: entry[2].casefold(),
        )
        self.results_sizer.Clear(delete_windows=True)
        self.composer_results.Layout()
        available = {entry[3] for entry in self.composer_entries if entry[3]}
        for letter, button in self.letter_buttons.items():
            if letter in available:
                _enable_button(button)
            else:
                _disable_button(button)

    # ------------------------------------------------------------------
    # Nom de fichier suggéré et gestion des champs optionnels
    # ------------------------------------------------------------------

    def build_default_filename(self):
        title = _safe_filename_part(self.fields["title"]["entry"].GetValue().strip())
        composer = self.fields["composer"]["entry"].GetValue().strip()
        if composer.startswith("\\"):
            display_name = self.composers.get(composer)
            if display_name:
                composer = composer_surname(display_name).title()
            else:
                composer = composer[1:].title()
        composer = _safe_filename_part(composer)
        if title and composer:
            return f"{title} - {composer}"
        return title or (f"Sans titre - {composer}" if composer else "")

    def on_title_or_composer_change(self, *_args):
        if not self.filename_modified:
            self.filename_entry.ChangeValue(self.build_default_filename())

    def on_filename_edit(self, _event=None):
        self.filename_modified = True

    def on_optional_field_selected(self, selected_label: str):
        """Affiche le champ optionnel choisi dans le menu « + », à sa place habituelle."""
        key = self._field_keys_by_label.get(selected_label)
        if key is None or key not in self.available_fields:
            return
        self.fields[key]["frame"].Show()
        self.available_fields.remove(key)
        self._refresh_field_order()
        self._refresh_add_field_menu()

        if key in PICKER_FIELDS:
            self._set_picker_target(key)
            self.show_composer_picker()

        self.fields[key]["entry"].SetFocus()
        self._update_scrolling()

    def remove_field(self, key: str):
        """Cache un champ et le remet dans le menu « + »."""
        field_info = self.fields[key]
        if not field_info["frame"].IsShown():
            return
        field_info["frame"].Hide()
        field_info["entry"].Clear()
        if key in ("title", "composer"):
            self.on_title_or_composer_change()
        if key not in self.available_fields:
            self.available_fields.append(key)
            self.available_fields.sort(key=self._field_order.__getitem__)
        self._refresh_field_order()
        self._refresh_add_field_menu()

        if key in PICKER_FIELDS:
            remaining = self._active_picker_fields()
            if not remaining:
                self.picker_frame.Hide()
                self.Layout()
            elif self.picker_target == key:
                self._set_picker_target(remaining[0])
        self._update_scrolling()

    def _refresh_field_order(self):
        self.fields_sizer.Clear(delete_windows=False)
        for field in self.fields.values():
            if field["frame"].IsShown():
                self.fields_sizer.Add(field["frame"], 0, wx.EXPAND | wx.BOTTOM, 5)
        self.left_scroll.Layout()

    def _refresh_add_field_menu(self):
        choices = ["+"] + [self.fields[key]["name"] for key in self.available_fields]
        self.add_field_menu.SetItems(choices)
        self.add_field_menu.SetSelection(0)

    def get_target_filename(self) -> str:
        """Nom de fichier final (``.ly`` ajouté), ou « Sans titre.ly » si vide."""
        filename = self.filename_entry.GetValue().strip()
        if filename.lower().endswith(".ly"):
            filename = filename[:-3].rstrip()
        if not filename:
            return "Sans titre.ly"
        validate_file_stem(filename)
        return filename + ".ly"

    def get_category(self) -> str:
        """Retourne le nom complet de la catégorie sélectionnée."""
        index = self.category_radio.GetSelection()
        if 0 <= index < len(self.categories):
            return self.categories[index]
        return self.categories[0]

    def get_values(self) -> dict[str, str]:
        """Valeurs des champs d'en-tête actuellement affichés."""
        return {
            key: info["entry"].GetValue().strip()
            for key, info in self.fields.items()
            if info["frame"].IsShown()
        }

    @staticmethod
    def _get_categories() -> list[str]:
        """Noms des dossiers numérotés à proposer comme catégorie (hors grégorien/assemblages/commandes)."""
        categories = []
        if PARTITIONS.is_dir():
            for entry in PARTITIONS.iterdir():
                if (
                    entry.is_dir()
                    and entry.name[:2].isdecimal()
                    and entry.name[:2] not in EXCLUDED_CATEGORY_PREFIXES
                ):
                    categories.append(entry.name)
        categories.sort(key=str.casefold)
        return categories


class PartsTab(wx.Panel):
    """Onglet « Parties » : choix des voix/instruments et de leurs réglages (couplets, schéma...)."""

    def __init__(self, master):
        super().__init__(master)
        main_sizer = wx.BoxSizer(wx.HORIZONTAL)
        left_frame = wx.Panel(self)
        left_sizer = wx.BoxSizer(wx.VERTICAL)
        left_frame.SetSizer(left_sizer)
        right_frame = wx.Panel(self)
        self.right_sizer = wx.BoxSizer(wx.VERTICAL)
        right_frame.SetSizer(self.right_sizer)
        main_sizer.Add(left_frame, 0, wx.EXPAND | wx.ALL, 8)
        main_sizer.Add(right_frame, 1, wx.EXPAND | wx.ALL, 8)
        self.SetSizer(main_sizer)

        self.parts: dict[str, dict] = {
            "Flûte": {},
            "Solo": {},
            "Choeur": {},
            "Clavier": {},
        }

        for part in self.parts:
            checkbox = wx.CheckBox(left_frame, label=part)
            checkbox.Bind(wx.EVT_CHECKBOX, self.update_parts_ui)
            left_sizer.Add(checkbox, 0, wx.ALL, 5)
            self.parts[part]["btn"] = checkbox

            voice_frame = wx.Panel(right_frame)
            voice_sizer = wx.BoxSizer(wx.VERTICAL)
            voice_frame.SetSizer(voice_sizer)
            self.parts[part]["frame"] = voice_frame
            voice_sizer.Add(wx.StaticText(voice_frame, label=part), 0, wx.ALL, 8)

            if part in ("Solo", "Choeur"):
                couplets_frame = wx.Panel(voice_frame)
                couplets_sizer = wx.BoxSizer(wx.HORIZONTAL)
                couplets_frame.SetSizer(couplets_sizer)
                couplets_sizer.Add(
                    wx.StaticText(couplets_frame, label="Couplets :"),
                    0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5,
                )
                count = wx.SpinCtrl(
                    couplets_frame, min=1, max=len(NUMBERS), initial=1,
                )
                self.parts[part]["couplets"] = count
                couplets_sizer.Add(count, 0, wx.ALIGN_CENTER_VERTICAL)
                voice_sizer.Add(couplets_frame, 0, wx.LEFT | wx.BOTTOM, 15)

            if part == "Choeur":
                schema = wx.ComboBox(
                    voice_frame, value="SA-TB",
                    choices=("SA-TB", "S-A-T-B", "SA-H", "S-S-A", "T-T-B", "T-T-B-B"),
                    style=wx.CB_DROPDOWN,
                )
                self.parts[part]["schema"] = schema
                schema.Bind(wx.EVT_COMBOBOX, self.schema_voices_changed)
                schema.Bind(wx.EVT_TEXT, self.schema_voices_changed)
                voice_sizer.Add(schema, 0, wx.LEFT | wx.BOTTOM, 15)
                shared = wx.CheckBox(voice_frame, label="Même paroles pour toutes les voix")
                shared.SetValue(True)
                self.parts[part]["meme_paroles"] = shared
                voice_sizer.Add(shared, 0, wx.LEFT | wx.BOTTOM, 15)

            elif part == "Clavier":
                instrument_type = wx.Choice(voice_frame, choices=("Piano", "Orgue"))
                instrument_type.SetSelection(0)
                instrument_type.Bind(wx.EVT_CHOICE, self.clavier_changed)
                self.parts[part]["type"] = instrument_type
                voice_sizer.Add(instrument_type, 0, wx.LEFT | wx.BOTTOM, 15)
                self._staff_rows = []
                self.parts[part]["staffs"] = []
                for staff_index, staff_label in enumerate(PIANO_STAFFS_FR):
                    row = wx.Panel(voice_frame)
                    row_sizer = wx.BoxSizer(wx.HORIZONTAL)
                    row.SetSizer(row_sizer)
                    staff_count = wx.SpinCtrl(
                        row, min=0, max=len(NUMBERS), initial=1,
                    )
                    self.parts[part]["staffs"].append(staff_count)
                    row_sizer.Add(staff_count, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5)
                    row_sizer.Add(wx.StaticText(row, label=staff_label), 0, wx.ALIGN_CENTER_VERTICAL)
                    self._staff_rows.append(row)
                    voice_sizer.Add(row, 0, wx.LEFT | wx.BOTTOM, 5)
                    if staff_index >= 2:
                        row.Hide()

            elif part == "Flûte":
                lyrics = wx.CheckBox(voice_frame, label="Paroles")
                self.parts[part]["paroles"] = lyrics
                voice_sizer.Add(lyrics, 0, wx.LEFT | wx.BOTTOM, 15)

            voice_sizer.SetSizeHints(voice_frame)
            voice_frame.Hide()
            self.right_sizer.Add(voice_frame, 0, wx.EXPAND | wx.ALL, 4)

        wx.CallAfter(self.schema_voices_changed)
        wx.CallAfter(self.clavier_changed)

    def _resize_part_frame(self, frame):
        """Réajuste une partie après l'affichage/le masquage d'un de ses réglages."""
        frame.Layout()
        frame.GetSizer().SetSizeHints(frame)
        self.right_sizer.Layout()
        self.Layout()

    def schema_voices_changed(self, *_args):
        """Affiche le choix « même paroles » dès que le chœur comporte plusieurs portées."""
        choir = self.parts["Choeur"]
        choir["meme_paroles"].Show("-" in choir["schema"].GetValue())
        self._resize_part_frame(choir["frame"])

    def clavier_changed(self, *_args):
        """Affiche la ligne « Pédalier » seulement pour l'orgue."""
        is_organ = self.parts["Clavier"]["type"].GetStringSelection() == "Orgue"
        self._staff_rows[2].Show(is_organ)
        self._resize_part_frame(self.parts["Clavier"]["frame"])

    def update_parts_ui(self, *_args):
        """Affiche/cache le panneau de réglages de chaque partie selon sa case à cocher."""
        self.Freeze()
        try:
            for config in self.parts.values():
                config["frame"].Show(config["btn"].GetValue())
            self.right_sizer.Layout()
            self.Layout()
        finally:
            self.Thaw()

    def get_active_parts(self) -> dict[str, str]:
        """Blocs Lilypond des parties cochées, validés, dans l'ordre d'affichage."""
        active: dict[str, str] = {}
        for name, config in self.parts.items():
            if not config["btn"].GetValue():
                continue
            if name == "Flûte":
                active[name] = flute_pack(bool(config["paroles"].GetValue()))
            elif name == "Solo":
                active[name] = solo_pack(config["couplets"].GetValue())
            elif name == "Choeur":
                active[name] = choir_pack(
                    config["schema"].GetValue().strip().upper(),
                    config["couplets"].GetValue(),
                    bool(config["meme_paroles"].GetValue()),
                )
            elif name == "Clavier":
                active[name] = clavier_pack(
                    [control.GetValue() for control in config["staffs"]],
                    config["type"].GetStringSelection() == "Orgue",
                )
        if not active:
            raise GenerationError("Sélectionnez au moins une partie dans l'onglet « Parties ».")
        return active


class MusicTab(wx.Panel):
    """Onglet « Réglages musicaux » : armure, mesure, anacrouse, tempo (texte + MIDI)."""

    def __init__(self, master):
        super().__init__(master)
        self.vars = {
            "Armure": {
                "val": ["c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "bes", "b"],
                "default": "c",
            },
            "Chiffre de mesure": {
                "val": ["4/4", "2/2", "2/4", "3/4", "3/2", "6/8", "9/8", "12/8"],
                "default": "4/4",
            },
            "Anacrouse": {
                "val": ["0"] + [str(2 ** i) for i in range(5)] + [str(2 ** i) + "." for i in range(5)],
                "default": "0",
            },
            "Indication de tempo": {
                "val": [
                    "Lento", "Adagio", "Andante", "Maestoso", "Presto", "Allegro",
                    "Andantino", "Adagio ma non troppo",
                ],
                "default": "",
            },
            "Tempo du midi": {
                "default": 70,
            },
        }

        grid = wx.FlexGridSizer(rows=len(self.vars), cols=2, vgap=8, hgap=8)
        grid.AddGrowableCol(1, 1)
        for row, (label, config) in enumerate(self.vars.items()):
            grid.Add(wx.StaticText(self, label=label, size=(150, -1)), 0, wx.ALIGN_CENTER_VERTICAL)
            if "val" in config:
                widget = wx.ComboBox(
                    self, value=config["default"], choices=config["val"],
                    size=(220, -1), style=wx.CB_DROPDOWN,
                )
            else:
                widget = wx.SpinCtrl(
                    self, min=20, max=400, initial=config["default"],
                )
            config["var"] = widget
            grid.Add(widget, 0, wx.EXPAND)
        self.SetSizer(grid)

    def _read(self, label: str) -> str:
        return str(self.vars[label]["var"].GetValue()).strip()

    def read_settings(self) -> MusicSettings:
        """Lit et valide les réglages musicaux."""
        key = self._read("Armure").lower()
        if not _KEY_RE.fullmatch(key):
            raise GenerationError(
                f"Armure invalide : « {key} ». Utilisez par exemple c, fis ou bes."
            )

        time_signature = re.sub(r"\s+", "", self._read("Chiffre de mesure"))
        if not _TIME_RE.fullmatch(time_signature):
            raise GenerationError(
                f"Chiffre de mesure invalide : « {time_signature} ». Exemple : 4/4."
            )
        numerator, denominator = (int(part) for part in time_signature.split("/"))
        if numerator < 1 or denominator < 1:
            raise GenerationError(
                f"Chiffre de mesure invalide : « {time_signature} ». Les deux nombres doivent être positifs."
            )

        partial = self._read("Anacrouse")
        if partial == "0":
            partial = ""
        elif not _PARTIAL_RE.fullmatch(partial):
            raise GenerationError(f"Anacrouse invalide : « {partial} ». Exemple : 4 ou 4.")
        elif int(partial.rstrip(".")) < 1:
            raise GenerationError(f"Anacrouse invalide : « {partial} ». Utilisez une durée positive.")

        tempo_text = self._read("Indication de tempo")
        midi_tempo = int(self.vars["Tempo du midi"]["var"].GetValue())
        if not 20 <= midi_tempo <= 400:
            raise GenerationError("Le tempo MIDI doit être compris entre 20 et 400.")

        return MusicSettings(key, time_signature, partial, tempo_text, midi_tempo)


class LilypondCreator(wx.Frame):
    """Fenêtre principale : assemble les 3 onglets et génère le fichier .ly final."""

    def __init__(self):
        super().__init__(
            None, title="Assistant de création de partition Lilypond", size=(960, 720),
        )
        outer_sizer = wx.BoxSizer(wx.VERTICAL)
        self.tabview = wx.Notebook(self)
        outer_sizer.Add(self.tabview, 1, wx.EXPAND | wx.ALL, 8)

        # Chaque onglet reçoit son contenu avant l'affichage de la fenêtre afin que
        # wxNotebook calcule correctement la taille de ses pages.
        self.header_frame = wx.Panel(self.tabview)
        self.parts_frame = wx.Panel(self.tabview)
        self.music_frame = wx.Panel(self.tabview)
        self.tabview.AddPage(self.header_frame, "Titres et en-têtes")
        self.tabview.AddPage(self.parts_frame, "Parties")
        self.tabview.AddPage(self.music_frame, "Réglages musicaux")

        self.header_tab = None
        self.parts_tab = None
        self.music_tab = None

        buttons = wx.BoxSizer(wx.HORIZONTAL)
        create_button = wx.Button(self, label="Créer", size=(160, -1))
        _use_system_button_colours(create_button)
        create_button.Bind(wx.EVT_BUTTON, self.create_lilypond_file)
        cancel_button = wx.Button(self, label="Annuler", size=(120, -1))
        _set_button_colours(cancel_button, MUTED_BUTTON_COLOUR, "#8f8f8f")
        cancel_button.Bind(wx.EVT_BUTTON, lambda _event: self.Close())
        buttons.Add(create_button, 0, wx.RIGHT, 10)
        buttons.Add(cancel_button)
        outer_sizer.Add(buttons, 0, wx.ALIGN_CENTER | wx.BOTTOM, 15)
        self.SetSizer(outer_sizer)
        self.Centre()
        wx.CallAfter(self._ensure_all_tabs_built)

    def _ensure_all_tabs_built(self):
        """Construit le contenu des onglets après le calcul de leur taille native."""
        if self.header_tab is None:
            self.header_tab = HeaderTab(self.header_frame)
            sizer = wx.BoxSizer(wx.VERTICAL)
            sizer.Add(self.header_tab, 1, wx.EXPAND)
            self.header_frame.SetSizer(sizer)
        if self.parts_tab is None:
            self.parts_tab = PartsTab(self.parts_frame)
            sizer = wx.BoxSizer(wx.VERTICAL)
            sizer.Add(self.parts_tab, 1, wx.EXPAND)
            self.parts_frame.SetSizer(sizer)
        if self.music_tab is None:
            self.music_tab = MusicTab(self.music_frame)
            sizer = wx.BoxSizer(wx.VERTICAL)
            sizer.Add(self.music_tab, 1, wx.EXPAND | wx.ALL, 15)
            self.music_frame.SetSizer(sizer)
        self.Layout()

    # ------------------------------------------------------------------
    # Génération du fichier .ly
    # ------------------------------------------------------------------

    def create_lilypond_file(self, _event=None):
        """Assemble le contenu Lilypond et l'écrit dans le fichier choisi par l'utilisateur."""
        self._ensure_all_tabs_built()

        try:
            settings = self.music_tab.read_settings()
            header_values = self.header_tab.get_values()
            filename = self.header_tab.get_target_filename()
            category = self.header_tab.get_category()
            parts = self.parts_tab.get_active_parts()
            content = build_document(
                settings, header_values, parts, self.header_tab.composers,
            )
        except GenerationError as error:
            wx.MessageBox(str(error), "Création impossible", wx.OK | wx.ICON_ERROR, self)
            return

        target_folder = PARTITIONS / category / Path(filename).stem
        filepath = self._resolve_target_path(target_folder, filename)
        if filepath.exists():
            choice = self._ask_existing_file(filepath)
            if choice == wx.ID_CANCEL:
                self.header_tab.filename_entry.SetFocus()
                return
            if choice == wx.ID_NO:
                self._open_in_frescobaldi(filepath)
                return

        try:
            target_folder.mkdir(parents=True, exist_ok=True)
            filepath.write_text(content, encoding="utf-8")
        except OSError as error:
            wx.MessageBox(
                f"Impossible de créer le fichier « {filepath} » :\n{error}",
                "Erreur d'écriture", wx.OK | wx.ICON_ERROR, self,
            )
            return

        self._open_in_frescobaldi(filepath)

    @staticmethod
    def _resolve_target_path(target_folder: Path, filename: str) -> Path:
        """Chemin final du fichier .ly, en évitant d'écraser un fichier « Sans titre »."""
        filepath = target_folder / filename
        if filename != "Sans titre.ly":
            return filepath
        counter = 1
        while filepath.exists():
            filepath = target_folder / f"Sans titre ({counter}).ly"
            counter += 1
        return filepath

    def _ask_existing_file(self, filepath: Path) -> int:
        """Demande quoi faire lorsqu'un fichier du même nom existe déjà."""
        dialog = wx.Dialog(self, title="Fichier existant")
        sizer = wx.BoxSizer(wx.VERTICAL)
        text = wx.StaticText(
            dialog,
            label=(
                f"Le fichier « {filepath.name} » existe déjà dans :\n"
                f"{filepath.parent}\n\nQue souhaitez-vous faire ?"
            ),
        )
        text.Wrap(520)
        sizer.Add(text, 1, wx.EXPAND | wx.ALL, 15)

        actions = wx.BoxSizer(wx.HORIZONTAL)
        action_buttons = {}
        for label, identifier in (
            ("Écraser", wx.ID_YES),
            ("Travailler sur le fichier existant", wx.ID_NO),
            ("Changer le nom", wx.ID_CANCEL),
        ):
            button = wx.Button(dialog, identifier, label)
            if identifier == wx.ID_CANCEL:
                _set_button_colours(button, MUTED_BUTTON_COLOUR, MUTED_BUTTON_HOVER_COLOUR)
            else:
                _use_system_button_colours(button)
            button.Bind(
                wx.EVT_BUTTON,
                lambda _event, value=identifier: dialog.EndModal(value),
            )
            action_buttons[identifier] = button
            actions.Add(button, 0, wx.RIGHT, 5)
        sizer.Add(actions, 0, wx.ALIGN_CENTER | wx.BOTTOM, 10)

        dialog.SetSizerAndFit(sizer)
        dialog.CentreOnParent()
        dialog.SetEscapeId(wx.ID_CANCEL)
        action_buttons[wx.ID_NO].SetDefault()
        wx.CallAfter(action_buttons[wx.ID_NO].SetFocus)
        result = dialog.ShowModal()
        dialog.Destroy()
        return result

    def _open_in_frescobaldi(self, filepath: Path):
        """Ouvre le fichier dans Frescobaldi (ou avec l'application par défaut)."""
        try:
            subprocess.Popen(["frescobaldi", str(filepath)])
        except OSError:
            try:
                launched = wx.LaunchDefaultApplication(str(filepath))
            except Exception:
                launched = False
            if not launched:
                wx.MessageBox(
                    f"Le fichier a été créé :\n{filepath}\n\n"
                    "Frescobaldi n'a pas pu être lancé.",
                    "Ouverture impossible", wx.OK | wx.ICON_WARNING, self,
                )
                return
        self.Close()


if __name__ == "__main__":
    app = wx.App(False)
    frame = LilypondCreator()
    frame.Show()
    app.MainLoop()
