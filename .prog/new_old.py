#!/usr/bin/env python3
"""Assistant graphique de création de nouvelles partitions Lilypond pour KergallScore.

Génère un fichier .ly pré-rempli (en-têtes, voix/instruments, réglages musicaux) à partir
des choix faits dans une interface customtkinter, puis ouvre le résultat dans Frescobaldi.
"""
import shutil
import subprocess
from pathlib import Path

import customtkinter as ctk

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

# Catégories numérotées à ne pas proposer dans le sélecteur (grégorien, assemblages, commandes).
EXCLUDED_CATEGORY_PREFIXES = ("08", "09", "99")


class HeaderTab(ctk.CTkFrame):
    """Onglet « Titres et en-têtes » : champs du \\header, catégorie et sélecteur de compositeur."""

    def __init__(self, master, app):
        super().__init__(master)
        self.default_font = app.default_font
        self.filename_modified = False

        self.left_frame = ctk.CTkFrame(self)
        self.left_frame.pack(side="left", fill="both", expand=True, anchor="n")

        # Champs pouvant contenir un nom choisi via le sélecteur de compositeur.
        self.picker_fields = ("composer", "poet", "arranger")

        # "title" et "composer" sont toujours affichés ; les autres sont ajoutés à la demande
        # via le menu "+" et retirés avec leur bouton "-".
        self.fields = {
            "dedication":   "Dédicace",
            "title":        "Titre",
            "subtitle":     "Sous-titre",
            "subsubtitle":  "Sous-sous-titre",
            "instrument":   "Instrument",
            "composer":     "Compositeur",
            "poet":         "Paroles",
            "meter":        "Mètre",
            "arranger":     "Arrangeur",
            "copyright":    "Copyrights (1ère page)",
            "tagline":      "Slogan (dernière page)"
        }
        self.available_fields = []
        
        label_width = 130
        for field in self.fields:
            name = self.fields[field]
            frame = ctk.CTkFrame(self.left_frame, fg_color="transparent")
            self.fields[field] = {"name": name, "var": ctk.StringVar(), "frame": frame}

            ctk.CTkLabel(
                frame, text=name, font=self.default_font, width=label_width, anchor="w"
            ).grid(row=0, column=0, padx=(0, 5), pady=2, sticky="w")

            entry = ctk.CTkEntry(frame, width=260, height=28, font=self.default_font, textvariable=self.fields[field]["var"])
            entry.grid(row=0, column=1, padx=(0, 10), pady=2)
            if field in self.picker_fields:
                entry.bind("<FocusIn>", lambda _e, k=field: self._set_picker_target(k))
            self.fields[field]["entry"] = entry

            self.fields[field]["remove"] = ctk.CTkButton(
                frame, text="-", width=28, height=28, fg_color="#E57373", hover_color="#EF9A9A",
                command=lambda k=field: self.remove_field(k)
            )
            self.fields[field]["remove"].grid(row=0, column=2, pady=2)

            if field in ("title", "composer"):
                frame.pack(pady=4, anchor="w")
            else:
                self.available_fields.append(field)

        self.add_field_var = ctk.StringVar()
        self.add_field_menu = ctk.CTkOptionMenu(
            self.left_frame, values=[self.fields[key]["name"] for key in self.available_fields], variable=self.add_field_var,
            width=40, font=self.default_font,command=self.on_optional_field_selected
        )
        self.add_field_menu.set("+")
        self.add_field_menu.pack(padx=10, pady=10, anchor="w")

        ctk.CTkLabel(self.left_frame, text="Catégorie").pack(side="top", pady=10, anchor="w")
        self.categories = self._get_categories()
        self.category_var = ctk.StringVar(value=self.categories[0] if self.categories else "13-Autres")
        
        for cat in self.categories:
            ctk.CTkRadioButton(
                self.left_frame, text=cat[3:], variable=self.category_var, value=cat,
                font=self.default_font,
                radiobutton_height=15, radiobutton_width=15
            ).pack(side="top", padx=5, pady=2, anchor="w")
        
        filename_frame = ctk.CTkFrame(self.left_frame, fg_color="transparent")
        self.filename_var = ctk.StringVar()
        ctk.CTkLabel(
            filename_frame, text="Nom du dossier", font=self.default_font, width=label_width, anchor="w"
        ).grid(row=0, column=0, padx=(0, 5), sticky="w")
        entry_filename = ctk.CTkEntry(filename_frame, width=260, height=28, font=self.default_font, textvariable=self.filename_var)
        entry_filename.grid(row=0, column=1, padx=(0, 10))
        entry_filename.bind("<KeyRelease>", self.on_filename_edit)
        filename_frame.pack(pady=4, anchor="w")
        
        self.fields["title"]["var"].trace_add("write", self.on_title_or_composer_change)
        self.fields["composer"]["var"].trace_add("write", self.on_title_or_composer_change)

        self.build_composer_picker()

    # ------------------------------------------------------------------
    # Sélecteur de compositeur (recherche par initiale du nom de famille)
    # ------------------------------------------------------------------

    def build_composer_picker(self):
        """Construit le panneau de sélection (lettres A-Z + résultats + bouton "Nouveau nom")."""
        self.composers = self.get_composers()
        self.composer_entries = sorted(
            ((key, name, self._composer_surname(name)) for key, name in self.composers.items()),
            key=lambda entry: entry[2]
        )

        self.picker_frame = ctk.CTkFrame(self)
        self.picker_target = "composer"

        letters_frame = ctk.CTkFrame(self.picker_frame, fg_color="transparent")
        letters_frame.pack(side="top", anchor="w")

        columns = 6
        letters_with_composers = {entry[2][:1].upper() for entry in self.composer_entries}
        self.letter_buttons = {}
        self.default_letter_fg_color = None
        for i, letter in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
            has_composers = letter in letters_with_composers
            btn = ctk.CTkButton(
                letters_frame, text=letter, width=30, height=28, font=self.default_font,
                state="normal" if has_composers else "disabled",
                fg_color=None if has_composers else "#4a4a4a",
                text_color_disabled="#8a8a8a",
                command=lambda l=letter: self.show_composers_for_letter(l)
            )
            btn.grid(row=i // columns, column=i % columns, padx=(5, 0), pady=2)
            self.letter_buttons[letter] = btn
            if has_composers and self.default_letter_fg_color is None:
                self.default_letter_fg_color = btn.cget("fg_color")

        self.composer_results = ctk.CTkFrame(self.picker_frame, width=260, fg_color="transparent")
        self.composer_results.pack(side="top", fill="x", pady=(10, 0))

        ctk.CTkButton(
            self.picker_frame, text="Nouveau nom", font=self.default_font,
            command=self.open_new_composer_popup
        ).pack(side="top", pady=5, anchor="w")

        self.show_composer_picker()

    def show_composer_picker(self):
        """Affiche le panneau de sélection s'il n'est pas déjà visible."""
        if not self.picker_frame.winfo_ismapped():
            self.picker_frame.pack(side="left", fill="both", expand=True, padx=(20, 0), anchor="n")

    def _set_picker_target(self, key):
        """Définit quel champ (compositeur/parolier/arrangeur) reçoit le prochain choix."""
        self.picker_target = key
    
    def _active_picker_fields(self):
        """Champs du sélecteur actuellement affichés."""
        return [key for key in self.picker_fields if self.fields[key]["frame"].winfo_manager() == "pack"]

    def show_composers_for_letter(self, letter):
        """Liste les compositeurs dont le nom de famille commence par ``letter``."""
        for widget in self.composer_results.winfo_children():
            widget.destroy()

        matches = [(key, name) for key, name, surname in self.composer_entries if surname[:1].upper() == letter]

        if not matches:
            ctk.CTkLabel(self.composer_results, text="Aucun compositeur", font=self.default_font).pack(anchor="w", pady=2)
            return

        for key, name in matches:
            ctk.CTkButton(
                self.composer_results, text=name.strip('"'), font=self.default_font, anchor="w",
                width=220, height=28,
                command=lambda k=key: self.fields[self.picker_target]["var"].set(k)
            ).pack(anchor="w", pady=2)

    def _composer_surname(self, name: str) -> str:
        """Nom de famille (dernier mot avant les dates entre parenthèses), en minuscules."""
        before_paren = name.strip('"').split("(")[0].strip()
        words = before_paren.split()
        return words[-1].lower() if words else before_paren.lower()

    def open_new_composer_popup(self):
        """Popup de saisie d'un nouveau compositeur/parolier/arrangeur."""
        popup = ctk.CTkToplevel(self)
        popup.title("Nouveau nom")
        popup.resizable(False, False)
        popup.wait_visibility()
        popup.grab_set()

        identifiant_var = ctk.StringVar()
        nom_var = ctk.StringVar()

        identifiant_frame = ctk.CTkFrame(popup, fg_color="transparent")
        ctk.CTkLabel(identifiant_frame, text="Identifiant", font=self.default_font, width=100).pack(side="left", padx=(10, 5), pady=10)
        ctk.CTkEntry(identifiant_frame, width=220, height=28, font=self.default_font, textvariable=identifiant_var).pack(side="left", padx=(0, 10), pady=10)
        identifiant_frame.pack(anchor="w")

        nom_frame = ctk.CTkFrame(popup, fg_color="transparent")
        ctk.CTkLabel(nom_frame, text="Nom et date", font=self.default_font, width=100).pack(side="left", padx=(10, 5), pady=10)
        ctk.CTkEntry(nom_frame, width=220, height=28, font=self.default_font, textvariable=nom_var).pack(side="left", padx=(0, 10), pady=10)
        nom_frame.pack(anchor="w")

        button_frame = ctk.CTkFrame(popup, fg_color="transparent")
        ctk.CTkButton(
            button_frame, text="Enregistrer", font=self.default_font,
            command=lambda: self.save_new_composer(identifiant_var.get().strip(), nom_var.get().strip(), popup)
        ).pack(side="left", padx=(10, 5), pady=10)
        ctk.CTkButton(
            button_frame, text="Annuler", font=self.default_font, fg_color="#8a8a8a", hover_color="#6a6a6a",
            command=popup.destroy
        ).pack(side="left", padx=(0, 10), pady=10)
        button_frame.pack(anchor="e")

    def save_new_composer(self, identifiant: str, nom: str, popup):
        """Ajoute le nom dans composers.ily, synchronise Lilypond, et rafraîchit le sélecteur."""
        if not identifiant or not nom:
            return

        content = COMPOSERS_FILE.read_text()
        if content and not content.endswith("\n"):
            content += "\n"
        COMPOSERS_FILE.write_text(content + f'{identifiant} = "{nom}"\n')

        # Recopie .utils/ vers l'installation lilypond locale (cf. tâche "Synchroniser .utils/").
        for utils_file in UTILS_DIR.iterdir():
            if utils_file.is_file():
                shutil.copy(utils_file, LILYPOND_LY_DIR)

        self.refresh_composers()
        popup.destroy()

    def refresh_composers(self):
        """Recharge composers.ily et met à jour l'état (actif/inactif) des lettres A-Z."""
        self.composers = self.get_composers()
        self.composer_entries = sorted(
            ((key, name, self._composer_surname(name)) for key, name in self.composers.items()),
            key=lambda entry: entry[2]
        )
        letters_with_composers = {entry[2][:1].upper() for entry in self.composer_entries}
        for letter, btn in self.letter_buttons.items():
            has_composers = letter in letters_with_composers
            btn.configure(
                state="normal" if has_composers else "disabled",
                fg_color=self.default_letter_fg_color if has_composers else "#4a4a4a"
            )

    # ------------------------------------------------------------------
    # Nom de fichier suggéré et gestion des champs optionnels
    # ------------------------------------------------------------------

    def build_default_filename(self):
        title = self.fields["title"]["var"].get().strip()
        composer = self.fields["composer"]["var"].get().strip()
        if composer and composer[0] == "\\":
            composer = composer[1:].title()
            if title:
                return f"{title} - {composer}"
        if title:
            return f"{title}"
        if composer:
            return f"Sans titre - {composer}"
        return ""

    def on_title_or_composer_change(self, *_args):
        if not self.filename_modified:
            default_name = self.build_default_filename()
            self.filename_var.set(default_name)

    def on_filename_edit(self, _event=None):
        self.filename_modified = True

    def on_optional_field_selected(self, selected_label: str):
        """Affiche le champ optionnel choisi dans le menu "+", à sa place habituelle."""
        selected_key = next(
            (key for key, info in self.fields.items() if info["name"] == selected_label),
            None,
        )
        
        insert_before_widget = None
        all_keys = list(self.fields.keys())
        selected_index = all_keys.index(selected_key)

        for key in all_keys[selected_index + 1:]:
            if self.fields[key]["frame"].winfo_manager() == "pack":
                insert_before_widget = self.fields[key]["frame"]
                break

        self.fields[selected_key]["frame"].pack(
            before=(insert_before_widget if insert_before_widget else self.add_field_menu),
            pady=4, anchor="w")
        
        self.available_fields.remove(selected_key)
        
        updated_values = [self.fields[key]["name"] for key in self.available_fields]
        self.add_field_menu.configure(values=updated_values)
        self.add_field_var.set("+")

        if selected_key in self.picker_fields:
            self._set_picker_target(selected_key)

        self.fields[selected_key]["entry"].focus_set()
        self.show_composer_picker()

    def remove_field(self, key: str):
        """Cache un champ optionnel et le remet dans le menu "+"."""
        field_info = self.fields[key]
        field_info["frame"].pack_forget()
        field_info["var"].set("")
        
        self.available_fields.append(key)
        self.available_fields.sort(key=lambda k: list(self.fields.keys()).index(k))
        
        updated_values = [self.fields[key]["name"] for key in self.available_fields]
        self.add_field_menu.configure(values=updated_values)
        self.add_field_var.set("+")

        if key in self.picker_fields:
            remaining = self._active_picker_fields()
            if not remaining:
                self.picker_frame.pack_forget()
            elif self.picker_target == key:
                self._set_picker_target(remaining[0])

    def get_target_filename(self) -> str:
        """Nom de fichier final (``.ly`` ajouté), ou "Sans titre.ly" si vide."""
        filename = self.filename_var.get().strip()
        if not filename:
            return "Sans titre.ly"
        return filename + ".ly"

    def _get_categories(self) -> list[str]:
        """Noms des dossiers numérotés à proposer comme catégorie (hors grégorien/assemblages/commandes)."""
        categories = [
            entry.name for entry in PARTITIONS.iterdir()
            if entry.name[:2].isdecimal()
            and entry.name[:2] not in EXCLUDED_CATEGORY_PREFIXES
        ]
        categories.sort(key=str.casefold)
        return categories
    
    def get_composers(self):
        """Associe chaque identifiant Lilypond (ex: ``\\bach``) au nom affiché du compositeur."""
        content = COMPOSERS_FILE.read_text().removeprefix('\\version "2.26.0"\n\n')
        composers = {}
        for line in content.splitlines():
            if not line.strip():
                continue
            identifiant, nom = line.split(" = ", 1)
            composers["\\" + identifiant] = nom
        return composers

    
class PartsTab(ctk.CTkFrame):
    """Onglet « Parties » : choix des voix/instruments et de leurs réglages (couplets, schéma...)."""

    def __init__(self, master, app):
        super().__init__(master)
        self.default_font = app.default_font

        left_frame = ctk.CTkFrame(self)
        left_frame.pack(side="left", fill="y", padx=(0, 10))
        
        right_frame = ctk.CTkFrame(self)
        right_frame.pack(side="left", fill="both", expand=True)

        self.parts = {
            "Flûte": {
                "paroles": ctk.BooleanVar(value=False)
            },
            "Solo": {
                "couplets": ctk.IntVar(value=1)
            },
            "Choeur": {
                "schema": ctk.StringVar(value="SA-TB"),
                "couplets": ctk.IntVar(value=1),
                "meme_paroles": ctk.BooleanVar(value=True)
            },
            "Clavier": {
                "type": ctk.StringVar(value="Piano"),
                "staffs": [ctk.IntVar(value=1), ctk.IntVar(value=1), ctk.IntVar(value=1)]
            }
        }

        for part in self.parts:
            self.parts[part]["btn"] = ctk.CTkCheckBox(
                left_frame, text=part, font=self.default_font,
                command=self.update_parts_ui
            )
            self.parts[part]["btn"].pack(pady=3, padx=10)
            
            voice_frame = ctk.CTkFrame(right_frame)
            self.parts[part]["frame"] = voice_frame
            
            ctk.CTkLabel(voice_frame, text=part, font=("Arial", 12, "bold"), width=70, anchor="w").pack(side="top", padx=15, pady=(8, 2), anchor="w")
            
            if part in ("Solo", "Choeur"):
                couplets_frame = ctk.CTkFrame(voice_frame, fg_color="transparent")
                ctk.CTkLabel(couplets_frame, text="Couplets :", font=self.default_font).pack(side="left", padx=(0, 5), pady=0)
                ctk.CTkEntry(couplets_frame, width=50, height=28, font=self.default_font,
                             textvariable=self.parts[part]["couplets"], justify="center").pack(side="left", padx=5, pady=0)
                couplets_frame.pack(side="top", padx=15, pady=2, anchor="w")
            
            if part == "Choeur":
                ctk.CTkComboBox(
                    voice_frame, variable=self.parts[part]["schema"],
                    values=("SA-TB", "S-A-T-B", "SA-H","S-S-A", "T-T-B", "T-T-B-B")
                ).pack(side="top", padx=15, pady=5, anchor="w")
                self.parts[part]["schema"].trace_add("write", self.schema_voices_changed)

                self.parts[part]["meme_paroles_switch"] = ctk.CTkCheckBox(
                    voice_frame, text="Même paroles pour toutes les voix", font=self.default_font,
                    variable=self.parts[part]["meme_paroles"]
                )
            
            elif part == "Clavier":
                ctk.CTkOptionMenu(
                    voice_frame, width=100, height=28, variable=self.parts[part]["type"],
                    values=("Piano", "Orgue"), command=self.clavier_changed
                ).pack(side="top", padx=15, pady=(2, 8), anchor="w")
                self.piano_staffes = []
                for indice, staff in enumerate(PIANO_STAFFS_FR):
                    self.piano_staffes.append(ctk.CTkFrame(voice_frame, fg_color="transparent"))
                    ctk.CTkEntry(
                        self.piano_staffes[indice], width=50, height=28, font=self.default_font, justify="center",
                        textvariable=self.parts["Clavier"]["staffs"][indice]
                    ).pack(side="left", padx=5)
                    ctk.CTkLabel(
                        self.piano_staffes[indice],
                        text=staff, font=self.default_font
                    ).pack(side="left")
                    if indice < 2:
                        self.piano_staffes[indice].pack(side="top", pady=5, anchor="w")
            
            elif part == "Flûte":
                ctk.CTkCheckBox(
                    voice_frame, text="Paroles", font=self.default_font,
                    variable=self.parts[part]["paroles"]
                ).pack(side="top", padx=15, pady=(2, 8), anchor="w")

    def schema_voices_changed(self, *_args):
        """Affiche le bouton "même paroles" seulement si le chœur a plus de 2 groupes de portées."""
        switch = self.parts["Choeur"]["meme_paroles_switch"]
        if self.parts["Choeur"]["schema"].get().count("-") > 1:
            switch.pack(side="top", padx=15, pady=(2, 8), anchor="w")
        else:
            switch.pack_forget()

    def clavier_changed(self, *_args):
        """Affiche la ligne "Pédalier" seulement pour l'orgue."""
        organ_voices = self.piano_staffes[2]
        ispacked = organ_voices.winfo_manager() == "pack"
        if self.parts["Clavier"]["type"].get() == "Piano":
            if ispacked:
                organ_voices.pack_forget()
        else:
            if not ispacked:
                organ_voices.pack(side="top", pady=5, anchor="w")

    def update_parts_ui(self):
        """Affiche/cache le panneau de réglages de chaque partie selon sa case à cocher."""
        order = list(self.parts.keys())
        for i, part in enumerate(order):
            frame = self.parts[part]["frame"]
            is_active = self.parts[part]["btn"].get() == 1
            is_visible = frame.winfo_manager() == "pack"
            
            if is_active and not is_visible:
                frame.pack(fill="x", pady=4, padx=10,
                           before=next((self.parts[p]["frame"] for p in order[i+1:] if self.parts[p]["frame"].winfo_manager() == "pack"), None))
            elif not is_active and is_visible:
                frame.pack_forget()

class MusicTab(ctk.CTkFrame):
    """Onglet « Réglages musicaux » : armure, mesure, anacrouse, tempo (texte + MIDI)."""

    def __init__(self, master, app):
        super().__init__(master)
        self.default_font = app.default_font
        
        self.vars = {
            "Armure": {
                "var": ctk.StringVar(value="c"),
                "val": ["c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "bes", "b"],
                "ly": "key"
            },
            "Chiffre de mesure": {
                "var": ctk.StringVar(value="4/4"),
                "val": ["4/4", "2/2", "2/4", "3/4", "3/2", "6/8", "9/8", "12/8"],
                "ly": "time"
            },
            "Anacrouse": {
                "def": "0",
                "var": ctk.StringVar(value="0"),
                "val": ["0"] + [str(2**i) for i in range(5)] + [str(2**i)+"." for i in range(5)],
                "ly": "partial"
            },
            "Indication de tempo": {
                "def": "",
                "var": ctk.StringVar(value=""),
                "val": ["Lento", "Adagio", "Andante", "Maestoso", "Presto", "Allegro", "Andantino", "Adagio ma non troppo"],
                "ly":"tempo"
            },
            "Tempo du midi": {
                "var": ctk.StringVar(value="70")
            }
        }

        self.columnconfigure(1, weight=1)

        for row, texte in enumerate(self.vars):
            ctk.CTkLabel(
                self, font=self.default_font, text=texte, anchor="w", width=140
            ).grid(row=row, column=0, padx=(15, 5), pady=6, sticky="w")

            if "val" in self.vars[texte]:
                widget = ctk.CTkComboBox(
                    self, variable=self.vars[texte]["var"],
                    values=self.vars[texte]["val"], width=160
                )
            else:
                widget = ctk.CTkEntry(
                    self, font=self.default_font,
                    textvariable=self.vars[texte]["var"], width=160
                )
            widget.grid(row=row, column=1, padx=5, pady=6, sticky="w")


# ==============================================================================
# Génération du code Lilypond (fonctions pures, sans dépendance à l'interface)
# ==============================================================================

def generic_var(identifier: str, expression: str, content: str = "") -> str:
    """Bloc Lilypond générique : ``identifiant = expression { contenu }``."""
    return f"{identifier} = {expression} {{\n{content}  \n}}\n\n"


def music_var(identifier: str, fixed: bool, high: bool, global_var: str) -> str:
    """Déclare une variable musicale (voix ou main d'instrument) basée sur ``global_var``."""
    mode = "\\fixed" if fixed else "\\relative"
    octave = "'" if high else ""
    return generic_var(identifier, f"{mode} c{octave}", f"  \\{global_var}\n")


def lyric_var(identifier: str, verse_number: int | None = None) -> str:
    """Déclare une variable de paroles (``\\lyricmode``), numérotée si ``verse_number`` est fourni."""
    prefix = ""
    if verse_number:
        alternate_side = " ##f" if verse_number % 2 else " ##t"
        prefix = f"\\strophemode {verse_number}{alternate_side} "
    return generic_var(identifier, f"{prefix}\\lyricmode")


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

def lyric_name(voice: str, verse_index: int, prefix_with_voice: bool) -> str:
    """Nom de variable pour un couplet de paroles (ex: ``sopranoVerseOne``)."""
    return (VOICES[voice] if prefix_with_voice else "") + "Verse" + NUMBERS[verse_index]

def voice_block(score_index: int, schema: str, staff_voice_index: int | None) -> str:
    """Ligne ``\\new Voice`` référençant la variable musicale correspondante.

    ``staff_voice_index`` est le rang de la voix dans sa portée (0, 1, ...) quand
    plusieurs voix partagent une même portée (ex: 2 voix d'hommes), sinon ``None``.
    """
    name = voice_name(score_index, schema)
    return (
        (" " if staff_voice_index is None else "    ") +
        '\\new Voice = "' + name + '" {' +
        (f"\\voice{NUMBERS[staff_voice_index]} " if staff_voice_index is not None else "") +
        "\\" + name + " }\n"
    )

def lyrics_block(voice: str, verse_index: int, prefix_with_voice: bool) -> str:
    """Bloc ``\\new Lyrics`` rattachant un couplet à sa voix."""
    return (
        "  \\new Lyrics \\with {\n    \\override VerticalAxisGroup.staff-affinity = #CENTER\n  }"
        f' \\lyricsto "{VOICES[voice]}" \\{lyric_name(voice, verse_index, prefix_with_voice)}\n'
    )

def choir_vars(schema: str, verse_count: int, shared_lyrics: bool) -> str:
    """Déclare les variables musicales et les couplets de paroles du chœur."""
    voices = schema.replace("-", "")
    text = ""
    for index, voice in enumerate(voices):
        text += music_var(voice_name(index, voices), voice in "AB", voice in "SA", "global")
        if not shared_lyrics:
            for verse_index in range(verse_count):
                verse_number = verse_index + 1 if verse_count > 1 else None
                text += lyric_var(lyric_name(voice, verse_index, True), verse_number)
        text += "\n"
    if shared_lyrics:
        for verse_index in range(verse_count):
            verse_number = verse_index + 1 if verse_count > 1 else None
            text += lyric_var(lyric_name("", verse_index, False), verse_number)
    text += "\n"
    return text

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
    
    for group_index, staff_letters in enumerate(staff_groups):
        is_polyphonic = len(staff_letters) > 1
        first_voice_index = sum(len(group) for group in staff_groups[:group_index])
        
        text += "  \\new Staff \\with {\n"
        if show_instrument_names:
            if is_polyphonic:
                names = " ".join(f'"{letter}."' for letter in staff_letters)
                text += f"  \tinstrumentName = \\markup \\center-column {{ {names} }}\n"
            else:
                text += f'  \tinstrumentName = "{staff_letters}."\n'
        text += (
            "    \\consists Merge_rests_engraver\n" if is_polyphonic
            else '    \\consists "Ambitus_engraver"\n'
        )
        
        if "B" in staff_letters or "H" in staff_letters:
            text += "    \\clef bass\n"
        elif staff_letters == "T":
            text += "    \\clef \"treble_8\"\n"

        text += "  } "

        if is_polyphonic:
            text += "<<\n"
            for voice_offset in range(len(staff_letters)):
                text += voice_block(first_voice_index + voice_offset, voices, voice_offset)
            text += "  >>\n"
        else:
            text += voice_block(first_voice_index, voices, None)
        
        if (len(staff_groups) > 2 and shared_lyrics) or group_index == 0:
            for verse_index in range(verse_count):
                text += lyrics_block(staff_letters[0], verse_index, not shared_lyrics)
            text += "\n"
    text += ">>\n\n"
    return text

def choir_pack(part_config: dict) -> str:
    """Assemble variables + portées pour la partie « Choeur » à partir de sa configuration UI."""
    schema = part_config["schema"].get()
    verse_count = part_config["couplets"].get()
    shared_lyrics = part_config["meme_paroles"].get()
    return choir_vars(schema, verse_count, shared_lyrics) + choir_staff(schema, verse_count, shared_lyrics)


# ---- Clavier (piano ou orgue) ---------------------------------------------

def piano_part_name(staff_index: int, voice_index: int | None) -> str:
    """Nom de variable pour une main de clavier, numérotée si plusieurs voix s'y superposent."""
    return PIANO_STAFFS[staff_index] + (NUMBERS[voice_index] if voice_index is not None else "")

def piano_vars(staffs: list[int]) -> str:
    """Déclare les variables musicales de chaque main (et voix superposées) du clavier."""
    text = ""
    for staff_index, voice_count in enumerate(staffs):
        if voice_count != 0:
            if voice_count == 1:
                text += music_var(
                    piano_part_name(staff_index, None),
                    False, staff_index == 0, "global")
            else:
                for voice_index in range(voice_count):
                    text += music_var(
                        piano_part_name(staff_index, voice_index),
                        False, staff_index == 0, "global")
    return text

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
        if voice_count != 0:
            text += (
                f'  \\new Staff = "{PIANO_STAFFS[staff_index]}" '+
                ("{ \\clef bass " if staff_index > 0 else "{ ")
                )
            if voice_count == 1:
                text += "\\"+piano_part_name(staff_index, None)+" }\n"
            else:
                text += "<< "
                for voice_index in range(voice_count):
                    text += "\\" + piano_part_name(staff_index, voice_index) + (" \\\\ " if voice_index < voice_count-1 else "")
                text += ">> }\n"
    return text + ">>\n\n"


def piano_pack(staffs: list[int]) -> str:
    """Assemble variables + portées du clavier (piano ou orgue)."""
    return piano_vars(staffs)+piano_staff(staffs)


# ---- Solo ------------------------------------------------------------------

def solo_vars(verse_count: int) -> str:
    """Déclare la voix soliste et ses couplets de paroles numérotés."""
    text = music_var(
        "soloVoice",
        True,
        True,
        "global"
    )
    for verse_index in range(verse_count):
        text += lyric_var(
            f"soloVerse{NUMBERS[verse_index]}",
            verse_index
        )
    return text

def solo_staff(verse_count: int) -> str:
    """Bloc ``SoloPart`` : une portée de soliste avec ses couplets en ``\\addlyrics``."""
    text = (
        "SoloPart = \\new Staff \\with {\n"
        '\tinstrumentName = "Solo"\n'
        '\tshortInstrumentName = "Sl."\n'
        '\tmidiInstrument = "choir aahs"\n'
        '  \\consists "Ambitus_engraver"\n'
        "} \\soloVoice\n"
    )
    for verse_index in range(verse_count):
        text += f"\\addlyrics \\soloVerse{NUMBERS[verse_index]}\n"
    return text+"\n\n"

def solo_pack(verse_count: int) -> str:
    """Assemble variables + portée du solo."""
    return solo_vars(verse_count) + solo_staff(verse_count)


# ---- Flûte -------------------------------------------------------------------

def flute_vars(has_lyrics: bool) -> str:
    """Déclare la voix de flûte et, si besoin, sa seule ligne de paroles."""
    text = music_var(
        "flute",
        True,
        True,
        "global"
    )
    if has_lyrics:
        text += lyric_var("fluteVerse")
    return text

def flute_staff(has_lyrics: bool) -> str:
    """Bloc ``FlûtePart`` : une portée de flûte, avec paroles optionnelles."""
    text = (
        "FlûtePart = \\new Staff \\with {\n"
        '\tinstrumentName = "Flûte"\n'
        '\tshortInstrumentName = "Fl."\n'
        '\tmidiInstrument = "flute"\n'
        "} \\flute\n"
    )
    if has_lyrics:
        text += "\\addlyrics \\fluteVerse\n"
    return text+"\n\n"

def flute_pack(has_lyrics: bool) -> str:
    """Assemble variable + portée de la flûte."""
    return flute_vars(has_lyrics)+flute_staff(has_lyrics)


def _build_clavier_block(config: dict) -> str:
    """Bloc du clavier : ne garde que les mains utiles (2 pour piano, 3 pour orgue)."""
    voice_counts = [staff_var.get() for staff_var in config["staffs"]]
    staff_count = 2 + (config["type"].get() == "Orgue")
    return piano_pack(voice_counts[:staff_count])


# Fonction de génération à appeler pour chaque partie activée dans l'onglet "Parties".
PART_BLOCK_BUILDERS = {
    "Flûte": lambda config: flute_pack(config["paroles"].get()),
    "Solo": lambda config: solo_pack(config["couplets"].get()),
    "Choeur": choir_pack,
    "Clavier": _build_clavier_block,
}


def _build_instruments_reference(active_parts: dict) -> str:
    """Référence les ``...Part`` déclarés : seul, ou combinés dans un ``<< >>``."""
    if len(active_parts) == 1:
        (name,) = active_parts
        return f"  \\{name}Part\n"
    lines = "".join(f"    \\{name}Part\n" for name in active_parts)
    return f"  <<\n{lines}  >>\n"


class LilypondCreator(ctk.CTk):
    """Fenêtre principale : assemble les 3 onglets et génère le fichier .ly final."""

    def __init__(self):
        super().__init__()
        self.withdraw()  # caché pendant la construction pour éviter un affichage progressif
        self.title("Assistant de création de partition Lilypond")
        self.geometry("700x600")

        self.default_font = ("Arial", 12)
        self.alert_same_path = True
        tabview = ctk.CTkTabview(self, anchor="nw", command=self._on_tab_change)
        tabview.pack(padx=10, pady=(10, 0), fill="both", expand=True, side="top")
        self.tabview = tabview

        # Les 3 cadres sont créés tout de suite (peu coûteux), mais le contenu de
        # "Parties" et "Réglages musicaux" n'est construit qu'à la première visite
        # de l'onglet correspondant, pour accélérer l'ouverture de la fenêtre.
        self.header_frame = tabview.add("Titres et en-têtes")
        self.parts_frame = tabview.add("Parties")
        self.music_frame = tabview.add("Réglages musicaux")

        self.header_tab = HeaderTab(self.header_frame, self)
        self.header_tab.pack(fill="both", expand=True)
        self.parts_tab = None
        self.music_tab = None

        button_frame = ctk.CTkFrame(self)
        ctk.CTkButton(button_frame, text="Créer", width=160, font=self.default_font, command=self.create_lilypond_file).pack(side="left", padx=(0, 10))
        ctk.CTkButton(button_frame, text="Annuler", width=120, font=self.default_font, fg_color="#8a8a8a", hover_color="#8f8f8f", command=self.destroy).pack(side="left")
        button_frame.pack(pady=15)

        self.update_idletasks()  # force le calcul complet du layout avant l'affichage
        self.deiconify()
        self.mainloop()

    def _on_tab_change(self):
        """Construit le contenu de l'onglet sélectionné s'il ne l'a pas encore été."""
        selected = self.tabview.get()
        if selected == "Parties" and self.parts_tab is None:
            self.parts_tab = PartsTab(self.parts_frame, self)
            self.parts_tab.pack(fill="both", expand=True)
        elif selected == "Réglages musicaux" and self.music_tab is None:
            self.music_tab = MusicTab(self.music_frame, self)
            self.music_tab.pack(fill="both", expand=True)

    def _ensure_all_tabs_built(self):
        """Construit les onglets pas encore visités, pour disposer de leurs valeurs par défaut."""
        if self.parts_tab is None:
            self.parts_tab = PartsTab(self.parts_frame, self)
            self.parts_tab.pack(fill="both", expand=True)
        if self.music_tab is None:
            self.music_tab = MusicTab(self.music_frame, self)
            self.music_tab.pack(fill="both", expand=True)

    # ------------------------------------------------------------------
    # Génération du fichier .ly
    # ------------------------------------------------------------------

    def create_lilypond_file(self):
        """Assemble le contenu Lilypond et l'écrit dans le fichier choisi par l'utilisateur."""
        self._ensure_all_tabs_built()
        header_values = self._collect_header_values()
        filename = self.header_tab.get_target_filename()
        category = self.header_tab.category_var.get().strip()
        target_folder = PARTITIONS / category / Path(filename).stem

        try:
            target_folder.mkdir(parents=True, exist_ok=True)
            self.filepath = self._resolve_target_path(target_folder, filename)

            active_parts = {
                name: config for name, config in self.parts_tab.parts.items() if config["btn"].get()
            }
            content = (
                self._build_global_block()
                + self._build_parts_block(active_parts)
                + self._build_toc_line(header_values)
                + self._build_score_block(header_values, active_parts)
            )
            self.filepath.write_text(content)
            self.happy_end()

        except OSError as error:
            self._show_error_dialog(error)

    def _collect_header_values(self) -> dict[str, str]:
        """Valeurs des champs d'en-tête actuellement affichés."""
        return {
            key: field["var"].get().strip()
            for key, field in self.header_tab.fields.items()
            if field["frame"].winfo_manager() == "pack"
        }

    def _resolve_target_path(self, target_folder: Path, filename: str) -> Path:
        """Chemin final du fichier .ly, en évitant d'écraser un fichier existant."""
        filepath = target_folder / filename
        if not (filepath.exists() and self.alert_same_path):
            return filepath
        if filename != "Sans titre.ly":
            category = self.header_tab.category_var.get().strip()
            raise OSError(f"Le fichier '{filename}' existe déjà dans la catégorie '{category}'. Veuillez modifier le nom du fichier.")
        counter = 1
        while (target_folder / f"Sans titre ({counter}).ly").exists():
            counter += 1
        return target_folder / f"Sans titre ({counter}).ly"

    def _build_global_block(self) -> str:
        """Bloc ``global`` : réglages communs (armure, mesure, anacrouse, tempo textuel)."""
        content = (
            "\\version \"2.26.0\"\n"
            "\\include \"settings.ily\"\n"
            "\\include \"composers.ily\"\n"
            "\n"
            "global = {\n"
            "  \\autoBeamOff\n"
            "  \\mergeDifferentlyHeadedOn\n"
            "  \\mergeDifferentlyDottedOn\n"
        )
        for setting in self.music_tab.vars.values():
            if "ly" in setting and ("def" not in setting or setting["var"].get() != setting["def"]):
                ly_keyword = setting["ly"]
                value = setting["var"].get()
                quote = '"' if ly_keyword == "tempo" else ""
                suffix = " \\major" if ly_keyword == "key" else ""
                content += f"  \\{ly_keyword} {quote}{value}{quote}{suffix}\n"
        return content + "}\n\n"

    def _build_parts_block(self, active_parts: dict) -> str:
        """Concatène les blocs Lilypond (variables + portées) de chaque partie activée."""
        return "".join(PART_BLOCK_BUILDERS[name](config) for name, config in active_parts.items())

    def _build_toc_line(self, header_values: dict) -> str:
        """Ligne de table des matières (``\\tocItem...``), si un titre est renseigné."""
        title = header_values.get("title")
        if not title:
            return ""
        composer: str = header_values.get("composer")
        if composer:
            if composer.startswith("\\"):
                composer = composer[1:].title()
            return f'\\tocItemComposer "{title}" "{composer}"\n'
        return f'\\tocItem \\markup "{title}"\n'

    def _build_header_fields(self, header_values: dict) -> str:
        """Lignes du bloc ``\\header`` : citations (compositeur/parolier/arrangeur) ou texte brut."""
        content = ""
        for key, val in header_values.items():
            if key in self.header_tab.picker_fields and val.startswith("\\"):
                if key == "poet":
                    val = '\\markup {"Paroles :" ' + val + '}'
                elif key == "arranger":
                    val = '\\markup {"Harmonisation :" ' + val + '}'
                content += f'    {key} = {val}\n'
            else:
                content += f'    {key} = "{val.upper() if key == "title" else val}"\n'
        return content

    def _build_score_block(self, header_values: dict, active_parts: dict) -> str:
        """Bloc ``\\score`` complet : en-tête, portées, mise en page et MIDI."""
        midi_tempo = self.music_tab.vars["Tempo du midi"]["var"].get()
        return (
            "\\score {\n"
            "  \\header {\n"
            + self._build_header_fields(header_values)
            + "  }\n"
            + _build_instruments_reference(active_parts)
            + "  \\layout {\\context{\\Staff \\RemoveAllEmptyStaves }}\n"
            + "  \\midi {\\tempo 4=" + midi_tempo + " }\n"
            + "}\n"
        )

    def _show_error_dialog(self, error: OSError):
        """Popup d'erreur avec choix : réessayer, écraser, ou continuer sur le fichier existant."""
        self.error_window = ctk.CTkToplevel(self)
        self.error_window.title("Erreur de création")
        self.error_window.resizable(False, False)
        
        ctk.CTkLabel(
            self.error_window, text=f"Une erreur est survenue :\n{str(error)}", 
            text_color="#D32F2F", wraplength=360, justify="center", font=self.default_font
        ).pack(expand=True, fill="both", pady=20, padx=20)
        
        btn_frame = ctk.CTkFrame(self.error_window)
        ctk.CTkButton(
            btn_frame, text="Rééssayer",
            font=self.default_font, command=self.relaunch
        ).pack(side="left")
        ctk.CTkButton(
            btn_frame, text="Ecraser le fichier existant",
            font=self.default_font, command=self.ecrase
        ).pack(side="left", padx=5)
        ctk.CTkButton(
            btn_frame, text="Travailler sur le fichier existant",
            font=self.default_font, command=self.happy_end
        ).pack(side="left", padx=5)
        btn_frame.pack(pady=10)

    # ------------------------------------------------------------------
    # Actions de fin (ouverture Frescobaldi, ré-essai, écrasement)
    # ------------------------------------------------------------------

    def happy_end(self):
        subprocess.Popen(["frescobaldi", str(self.filepath)])
        self.destroy()
    
    def ecrase(self):
        self.alert_same_path = False
        self.create_lilypond_file()

    def relaunch(self):
        self.error_window.destroy()
        self.create_lilypond_file()

LilypondCreator()
