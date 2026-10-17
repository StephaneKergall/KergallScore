#!/usr/bin/env python3
"""Assistant graphique de création de nouvelles partitions Lilypond pour KergallScore.

Génère un fichier .ly pré-rempli à partir des choix faits dans l'interface wxPython,
puis ouvre le résultat dans Frescobaldi.
"""
import shutil
import subprocess
from pathlib import Path

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

# Catégories numérotées à ne pas proposer dans le sélecteur (grégorien, assemblages, commandes).
EXCLUDED_CATEGORY_PREFIXES = ("08", "09", "99")

# couleurs des boutons et du texte
REMOVE_BUTTON_COLOUR = "#E57373"
REMOVE_BUTTON_HOVER_COLOUR = "#EF9A9A"
MUTED_BUTTON_COLOUR = "#8a8a8a"
MUTED_BUTTON_HOVER_COLOUR = "#6a6a6a"
DISABLED_BUTTON_COLOUR = "#4a4a4a"
DISABLED_TEXT_COLOUR = "#8a8a8a"
ERROR_TEXT_COLOUR = "#D32F2F"


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


class HeaderTab(wx.Panel):
    """Onglet « Titres et en-têtes » : champs du \\header, catégorie et sélecteur de compositeur."""

    def __init__(self, master, app):
        super().__init__(master)
        self.filename_modified = False
        self._updating_filename = False
        self.root_sizer = wx.BoxSizer(wx.HORIZONTAL)
        self.left_scroll = wx.ScrolledWindow(self, style=wx.VSCROLL)
        self.left_sizer = wx.BoxSizer(wx.VERTICAL)
        self.left_scroll.SetSizer(self.left_sizer)
        self.fields_sizer = wx.BoxSizer(wx.VERTICAL)
        self.left_sizer.Add(self.fields_sizer, 0, wx.EXPAND)
        self.root_sizer.Add(self.left_scroll, 1, wx.EXPAND | wx.ALL, 8)
        self.SetSizer(self.root_sizer)

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
        
        for field in self.fields:
            name = self.fields[field]
            frame = wx.Panel(self.left_scroll)
            row_sizer = wx.BoxSizer(wx.HORIZONTAL)
            frame.SetSizer(row_sizer)
            row_sizer.Add(wx.StaticText(frame, label=name, size=(145, -1)), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5)
            entry = wx.TextCtrl(frame, size=(260, -1))
            row_sizer.Add(entry, 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 8)
            if field in self.picker_fields:
                entry.Bind(wx.EVT_SET_FOCUS, lambda _event, key=field: self._set_picker_target(key))
            remove = wx.Button(frame, label="-", size=(42, -1))
            _set_button_colours(remove, REMOVE_BUTTON_COLOUR, REMOVE_BUTTON_HOVER_COLOUR)
            remove.Bind(wx.EVT_BUTTON, lambda _event, key=field: self.remove_field(key))
            row_sizer.Add(remove, 0, wx.ALIGN_CENTER_VERTICAL)
            self.fields[field] = {"name": name, "entry": entry, "frame": frame}

            if field in ("title", "composer"):
                self.fields_sizer.Add(frame, 0, wx.EXPAND | wx.BOTTOM, 5)
            else:
                frame.Hide()
                self.available_fields.append(field)

        self.add_field_menu = wx.Choice(
            self.left_scroll,
            choices=["+"] + [self.fields[key]["name"] for key in self.available_fields],
        )
        self.add_field_menu.SetSelection(0)
        self.add_field_menu.Bind(wx.EVT_CHOICE, self._on_optional_field_choice)
        self.left_sizer.Add(self.add_field_menu, 0, wx.ALL, 8)

        self.left_sizer.Add(wx.StaticText(self.left_scroll, label="Catégorie"), 0, wx.LEFT | wx.TOP, 8)
        self.categories = self._get_categories()
        if not self.categories:
            self.categories = ["13-Autres"]
        self.category_radio = wx.RadioBox(
            self.left_scroll, label="", choices=[cat[3:] for cat in self.categories],
            majorDimension=1, style=wx.RA_SPECIFY_COLS,
        )
        self.category_radio.SetSelection(0)
        self.left_sizer.Add(self.category_radio, 0, wx.EXPAND | wx.ALL, 5)

        filename_frame = wx.Panel(self.left_scroll)
        filename_sizer = wx.BoxSizer(wx.HORIZONTAL)
        filename_frame.SetSizer(filename_sizer)
        filename_sizer.Add(wx.StaticText(filename_frame, label="Nom du dossier", size=(145, -1)), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5)
        self.filename_entry = wx.TextCtrl(filename_frame, size=(260, -1))
        filename_sizer.Add(self.filename_entry, 0, wx.ALIGN_CENTER_VERTICAL)
        self.left_sizer.Add(filename_frame, 0, wx.EXPAND | wx.ALL, 5)
        self.filename_entry.Bind(wx.EVT_TEXT, self.on_filename_edit)
        self.fields["title"]["entry"].Bind(wx.EVT_TEXT, self.on_title_or_composer_change)
        self.fields["composer"]["entry"].Bind(wx.EVT_TEXT, self.on_title_or_composer_change)

        self.build_composer_picker()
        wx.CallAfter(self._initialize_scrolling)

    def _initialize_scrolling(self):
        """Calcule la taille du contenu sans créer une barre de défilement vide."""
        self.left_scroll.FitInside()

    def _update_scrolling(self):
        """N'active la barre verticale que si le contenu dépasse la zone visible."""
        self.left_scroll.Layout()
        self.left_scroll.FitInside()
        if (
            self.left_scroll.GetVirtualSize().height > self.left_scroll.GetClientSize().height
            and self.left_scroll.GetScrollPixelsPerUnit()[1] == 0
        ):
            self.left_scroll.SetScrollRate(0, 12)

    def _on_optional_field_choice(self, event):
        if event.GetSelection():
            self.on_optional_field_selected(event.GetString())

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

        self.picker_frame = wx.Panel(self)
        picker_sizer = wx.BoxSizer(wx.VERTICAL)
        self.picker_frame.SetSizer(picker_sizer)
        self.picker_target = "composer"

        letters_frame = wx.Panel(self.picker_frame)
        letters_sizer = wx.GridSizer(0, 6, 2, 5)
        letters_frame.SetSizer(letters_sizer)
        columns = 6
        letters_with_composers = {entry[2][:1].upper() for entry in self.composer_entries}
        self.letter_buttons = {}
        for i, letter in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
            has_composers = letter in letters_with_composers
            btn = wx.Button(letters_frame, label=letter, size=(34, 28))
            btn.Enable(has_composers)
            if not has_composers:
                _set_button_colours(btn, DISABLED_BUTTON_COLOUR, DISABLED_BUTTON_COLOUR, DISABLED_TEXT_COLOUR)
            btn.Bind(wx.EVT_BUTTON, lambda _event, selected=letter: self.show_composers_for_letter(selected))
            letters_sizer.Add(btn, 0)
            self.letter_buttons[letter] = btn
        picker_sizer.Add(letters_frame, 0, wx.EXPAND)

        self.composer_results = wx.Panel(self.picker_frame)
        self.results_sizer = wx.BoxSizer(wx.VERTICAL)
        self.composer_results.SetSizer(self.results_sizer)
        picker_sizer.Add(self.composer_results, 0, wx.EXPAND | wx.TOP, 10)

        new_composer = wx.Button(self.picker_frame, label="Nouveau nom")
        new_composer.Bind(wx.EVT_BUTTON, lambda _event: self.open_new_composer_popup())
        picker_sizer.Add(new_composer, 0, wx.TOP, 8)
        self.root_sizer.Add(self.picker_frame, 0, wx.ALL | wx.EXPAND, 12)

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
        return [key for key in self.picker_fields if self.fields[key]["frame"].IsShown()]

    def show_composers_for_letter(self, letter):
        """Liste les compositeurs dont le nom de famille commence par ``letter``."""
        self.results_sizer.Clear(delete_windows=True)

        matches = [(key, name) for key, name, surname in self.composer_entries if surname[:1].upper() == letter]

        if not matches:
            self.results_sizer.Add(wx.StaticText(self.composer_results, label="Aucun compositeur"), 0, wx.ALL, 2)
            self.composer_results.Layout()
            return

        for key, name in matches:
            button = wx.Button(self.composer_results, label=name.strip('"'), size=(240, -1))
            _use_system_button_colours(button)
            button.Bind(wx.EVT_BUTTON, lambda _event, selected=key: self.fields[self.picker_target]["entry"].SetValue(selected))
            self.results_sizer.Add(button, 0, wx.ALL, 2)
        self.composer_results.Layout()
        self.Layout()

    def _composer_surname(self, name: str) -> str:
        """Nom de famille (dernier mot avant les dates entre parenthèses), en minuscules."""
        before_paren = name.strip('"').split("(")[0].strip()
        words = before_paren.split()
        return words[-1].lower() if words else before_paren.lower()

    def open_new_composer_popup(self):
        """Popup de saisie d'un nouveau compositeur/parolier/arrangeur."""
        popup = wx.Dialog(self, title="Nouveau nom")
        popup_sizer = wx.BoxSizer(wx.VERTICAL)
        fields = {}
        for key, label in (("identifiant", "Identifiant"), ("nom", "Nom et date")):
            row = wx.BoxSizer(wx.HORIZONTAL)
            row.Add(wx.StaticText(popup, label=label, size=(105, -1)), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5)
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
        save.Bind(wx.EVT_BUTTON, lambda _event: self.save_new_composer(
            fields["identifiant"].GetValue().strip(), fields["nom"].GetValue().strip(), popup
        ))
        popup.SetEscapeId(wx.ID_CANCEL)
        popup.ShowModal()
        popup.Destroy()

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
        popup.EndModal(wx.ID_OK)

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
            btn.Enable(has_composers)
            if not has_composers:
                _set_button_colours(btn, DISABLED_BUTTON_COLOUR, DISABLED_BUTTON_COLOUR, DISABLED_TEXT_COLOUR)

    # ------------------------------------------------------------------
    # Nom de fichier suggéré et gestion des champs optionnels
    # ------------------------------------------------------------------

    def build_default_filename(self):
        title = self.fields["title"]["entry"].GetValue().strip()
        composer = self.fields["composer"]["entry"].GetValue().strip()
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
            self._updating_filename = True
            self.filename_entry.SetValue(default_name)
            self._updating_filename = False

    def on_filename_edit(self, _event=None):
        if not self._updating_filename:
            self.filename_modified = True

    def on_optional_field_selected(self, selected_label: str):
        """Affiche le champ optionnel choisi dans le menu "+", à sa place habituelle."""
        selected_key = next(key for key, info in self.fields.items() if info["name"] == selected_label)
        self.fields[selected_key]["frame"].Show()
        self._refresh_field_order()
        self.available_fields.remove(selected_key)
        self._refresh_add_field_menu()

        if selected_key in self.picker_fields:
            self._set_picker_target(selected_key)

        self.fields[selected_key]["entry"].SetFocus()
        self.show_composer_picker()
        self._update_scrolling()

    def remove_field(self, key: str):
        """Cache un champ optionnel et le remet dans le menu "+"."""
        field_info = self.fields[key]
        field_info["frame"].Hide()
        field_info["entry"].Clear()
        self._refresh_field_order()
        
        self.available_fields.append(key)
        self.available_fields.sort(key=lambda k: list(self.fields.keys()).index(k))
        self._refresh_add_field_menu()

        if key in self.picker_fields:
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
        self._update_scrolling()

    def get_target_filename(self) -> str:
        """Nom de fichier final (``.ly`` ajouté), ou "Sans titre.ly" si vide."""
        filename = self.filename_entry.GetValue().strip()
        if not filename:
            return "Sans titre.ly"
        return filename + ".ly"

    def get_category(self) -> str:
        """Retourne le nom complet de la catégorie sélectionnée."""
        return self.categories[self.category_radio.GetSelection()]

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

    
class PartsTab(wx.Panel):
    """Onglet « Parties » : choix des voix/instruments et de leurs réglages (couplets, schéma...)."""

    def __init__(self, master, app):
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

        self.parts = {
            "Flûte": {
                "paroles": None
            },
            "Solo": {
                "couplets": None
            },
            "Choeur": {
                "schema": None,
                "couplets": None,
                "meme_paroles": None
            },
            "Clavier": {
                "type": None,
                "staffs": []
            }
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
                couplets_sizer.Add(wx.StaticText(couplets_frame, label="Couplets :"), 0, wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 5)
                count = wx.TextCtrl(couplets_frame, value="1", size=(55, -1), style=wx.TE_CENTRE)
                self.parts[part]["couplets"] = count
                couplets_sizer.Add(count)
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
                shared_lyrics = wx.CheckBox(voice_frame, label="Même paroles pour toutes les voix")
                shared_lyrics.SetValue(True)
                shared_lyrics.SetMinSize(shared_lyrics.GetBestSize())
                self.parts[part]["meme_paroles"] = shared_lyrics
                self.parts[part]["meme_paroles_switch"] = shared_lyrics
                voice_sizer.Add(shared_lyrics, 0, wx.LEFT | wx.BOTTOM, 15)

            elif part == "Clavier":
                instrument_type = wx.Choice(voice_frame, choices=("Piano", "Orgue"))
                instrument_type.SetSelection(0)
                instrument_type.Bind(wx.EVT_CHOICE, self.clavier_changed)
                self.parts[part]["type"] = instrument_type
                voice_sizer.Add(instrument_type, 0, wx.LEFT | wx.BOTTOM, 15)
                self.piano_staffes = []
                for indice, staff in enumerate(PIANO_STAFFS_FR):
                    row = wx.Panel(voice_frame)
                    row_sizer = wx.BoxSizer(wx.HORIZONTAL)
                    row.SetSizer(row_sizer)
                    staff_count = wx.TextCtrl(row, value="1", size=(55, -1), style=wx.TE_CENTRE)
                    self.parts["Clavier"]["staffs"].append(staff_count)
                    row_sizer.Add(staff_count, 0, wx.RIGHT, 5)
                    row_sizer.Add(wx.StaticText(row, label=staff), 0, wx.ALIGN_CENTER_VERTICAL)
                    self.piano_staffes.append(row)
                    voice_sizer.Add(row, 0, wx.LEFT | wx.BOTTOM, 5)
                    if indice >= 2:
                        row.Hide()

            elif part == "Flûte":
                lyrics = wx.CheckBox(voice_frame, label="Paroles")
                self.parts[part]["paroles"] = lyrics
                voice_sizer.Add(lyrics, 0, wx.LEFT | wx.BOTTOM, 15)
            voice_sizer.SetSizeHints(voice_frame)
            voice_frame.Hide()
            self.right_sizer.Add(voice_frame, 0, wx.EXPAND | wx.ALL, 4)
        wx.CallAfter(self.schema_voices_changed)

    def schema_voices_changed(self, *_args):
        """Affiche le bouton "même paroles" seulement si le chœur a plus de 2 groupes de portées."""
        switch = self.parts["Choeur"]["meme_paroles_switch"]
        switch.Show(self.parts["Choeur"]["schema"].GetValue().count("-") > 1)
        self.Layout()

    def clavier_changed(self, *_args):
        """Affiche la ligne "Pédalier" seulement pour l'orgue."""
        self.piano_staffes[2].Show(self.parts["Clavier"]["type"].GetStringSelection() == "Orgue")
        self.Layout()

    def update_parts_ui(self, *_args):
        """Affiche/cache le panneau de réglages de chaque partie selon sa case à cocher."""
        for part in self.parts.values():
            part["frame"].Show(part["btn"].GetValue())
        self.right_sizer.Layout()
        self.Layout()


class MusicTab(wx.Panel):
    """Onglet « Réglages musicaux » : armure, mesure, anacrouse, tempo (texte + MIDI)."""

    def __init__(self, master, app):
        super().__init__(master)
        self.vars = {
            "Armure": {
                "var": None,
                "val": ["c", "cis", "d", "dis", "e", "f", "fis", "g", "gis", "a", "bes", "b"],
                "ly": "key"
            },
            "Chiffre de mesure": {
                "var": None,
                "val": ["4/4", "2/2", "2/4", "3/4", "3/2", "6/8", "9/8", "12/8"],
                "ly": "time"
            },
            "Anacrouse": {
                "def": "0",
                "var": None,
                "val": ["0"] + [str(2**i) for i in range(5)] + [str(2**i)+"." for i in range(5)],
                "ly": "partial"
            },
            "Indication de tempo": {
                "def": "",
                "var": None,
                "val": ["Lento", "Adagio", "Andante", "Maestoso", "Presto", "Allegro", "Andantino", "Adagio ma non troppo"],
                "ly":"tempo"
            },
            "Tempo du midi": {
                "var": None
            }
        }

        grid = wx.FlexGridSizer(rows=len(self.vars), cols=2, vgap=8, hgap=8)
        grid.AddGrowableCol(1, 1)
        for row, texte in enumerate(self.vars):
            grid.Add(wx.StaticText(self, label=texte, size=(150, -1)), 0, wx.ALIGN_CENTER_VERTICAL)

            if "val" in self.vars[texte]:
                widget = wx.ComboBox(
                    self, value=self.vars[texte]["def"] if texte in ("Anacrouse", "Indication de tempo") else
                    ("c" if texte == "Armure" else "4/4"),
                    choices=self.vars[texte]["val"], size=(180, -1), style=wx.CB_DROPDOWN,
                )
            else:
                widget = wx.TextCtrl(self, value="70", size=(180, -1))
            self.vars[texte]["var"] = widget
            grid.Add(widget, 0, wx.EXPAND)
        self.SetSizer(grid)


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
    schema = part_config["schema"].GetValue()
    verse_count = int(part_config["couplets"].GetValue())
    shared_lyrics = part_config["meme_paroles"].GetValue()
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
    voice_counts = [int(staff_var.GetValue()) for staff_var in config["staffs"]]
    staff_count = 2 + (config["type"].GetStringSelection() == "Orgue")
    return piano_pack(voice_counts[:staff_count])


# Fonction de génération à appeler pour chaque partie activée dans l'onglet "Parties".
PART_BLOCK_BUILDERS = {
    "Flûte": lambda config: flute_pack(config["paroles"].GetValue()),
    "Solo": lambda config: solo_pack(int(config["couplets"].GetValue())),
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


class LilypondCreator(wx.Frame):
    """Fenêtre principale : assemble les 3 onglets et génère le fichier .ly final."""

    def __init__(self):
        super().__init__(None, title="Assistant de création de partition Lilypond", size=(900, 700))
        self.alert_same_path = True
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
            self.header_tab = HeaderTab(self.header_frame, self)
            sizer = wx.BoxSizer(wx.VERTICAL)
            sizer.Add(self.header_tab, 1, wx.EXPAND)
            self.header_frame.SetSizer(sizer)
        if self.parts_tab is None:
            self.parts_tab = PartsTab(self.parts_frame, self)
            sizer = wx.BoxSizer(wx.VERTICAL)
            sizer.Add(self.parts_tab, 1, wx.EXPAND)
            self.parts_frame.SetSizer(sizer)
        if self.music_tab is None:
            self.music_tab = MusicTab(self.music_frame, self)
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
        header_values = self._collect_header_values()
        filename = self.header_tab.get_target_filename()
        category = self.header_tab.get_category()
        target_folder = PARTITIONS / category / Path(filename).stem

        try:
            target_folder.mkdir(parents=True, exist_ok=True)
            self.filepath = self._resolve_target_path(target_folder, filename)

            active_parts = {
                name: config for name, config in self.parts_tab.parts.items() if config["btn"].GetValue()
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
            key: field["entry"].GetValue().strip()
            for key, field in self.header_tab.fields.items()
            if field["frame"].IsShown()
        }

    def _resolve_target_path(self, target_folder: Path, filename: str) -> Path:
        """Chemin final du fichier .ly, en évitant d'écraser un fichier existant."""
        filepath = target_folder / filename
        if not (filepath.exists() and self.alert_same_path):
            return filepath
        if filename != "Sans titre.ly":
            category = self.header_tab.get_category()
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
            if "ly" in setting and ("def" not in setting or setting["var"].GetValue() != setting["def"]):
                ly_keyword = setting["ly"]
                value = setting["var"].GetValue()
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
        midi_tempo = self.music_tab.vars["Tempo du midi"]["var"].GetValue()
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
        self.error_window = wx.Dialog(self, title="Erreur de création", size=(620, 190))
        dialog_sizer = wx.BoxSizer(wx.VERTICAL)
        message = wx.StaticText(self.error_window, label=f"Une erreur est survenue :\n{str(error)}")
        message.SetForegroundColour(wx.Colour(ERROR_TEXT_COLOUR))
        message.Wrap(570)
        dialog_sizer.Add(message, 1, wx.EXPAND | wx.ALL, 15)
        actions = wx.BoxSizer(wx.HORIZONTAL)
        for label, action in (
            ("Rééssayer", self.relaunch),
            ("Ecraser le fichier existant", self.ecrase),
            ("Travailler sur le fichier existant", self.happy_end),
        ):
            button = wx.Button(self.error_window, label=label)
            _use_system_button_colours(button)
            button.Bind(wx.EVT_BUTTON, lambda _event, callback=action: callback())
            actions.Add(button, 0, wx.RIGHT, 5)
        dialog_sizer.Add(actions, 0, wx.ALIGN_CENTER | wx.BOTTOM, 10)
        self.error_window.SetSizer(dialog_sizer)
        self.error_window.CentreOnParent()
        self.error_window.Show()

    # ------------------------------------------------------------------
    # Actions de fin (ouverture Frescobaldi, ré-essai, écrasement)
    # ------------------------------------------------------------------

    def happy_end(self):
        subprocess.Popen(["frescobaldi", str(self.filepath)])
        self.Close()
    
    def ecrase(self):
        self.alert_same_path = False
        self.create_lilypond_file()

    def relaunch(self):
        self.error_window.Destroy()
        self.create_lilypond_file()


if __name__ == "__main__":
    app = wx.App(False)
    frame = LilypondCreator()
    frame.Show()
    app.MainLoop()
