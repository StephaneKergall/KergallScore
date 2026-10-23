#!/usr/bin/env bash
# Pipeline OCR : PDF scanné -> MusicXML (Audiveris) -> LilyPond.
#
# Usage :
#   scanned_to_ly.sh <partition.pdf> <dossier_sortie> <nom_piece>
#
# Prérequis : Audiveris (Java) et musicxml2ly (fourni par LilyPond).
# Ne devine jamais les notes : si Audiveris est absent, le script s'arrête.
set -euo pipefail

PDF=${1:?usage: scanned_to_ly.sh <pdf> <out_dir> <name>}
OUT=${2:?usage: scanned_to_ly.sh <pdf> <out_dir> <name>}
NAME=${3:?usage: scanned_to_ly.sh <pdf> <out_dir> <name>}

ROOT=$(cd "$(dirname "$0")/../../../.." && pwd)
LILY="$ROOT/.prog/lilypond-2.26.0/bin/lilypond"
MUSICXML2LY="$ROOT/.prog/lilypond-2.26.0/bin/musicxml2ly"

if [[ ! -f "$PDF" ]]; then
  echo "PDF introuvable : $PDF" >&2
  exit 1
fi

AUDIVERIS=$(command -v audiveris || command -v Audiveris || true)
if [[ -z "$AUDIVERIS" ]]; then
  cat >&2 <<'EOF'
Audiveris est absent. Installe-le (Java requis) :
  https://audiveris.github.io/audiveris/
Puis relance ce script. Sinon, fournis un PDF vectoriel, un MusicXML ou un MIDI.
EOF
  exit 2
fi

if [[ ! -x "$MUSICXML2LY" ]]; then
  MUSICXML2LY=$(command -v musicxml2ly || true)
fi
if [[ -z "$MUSICXML2LY" ]]; then
  echo "musicxml2ly introuvable (ni .prog/lilypond-2.26.0/bin ni PATH)." >&2
  exit 3
fi

mkdir -p "$OUT" "$(dirname "$OUT/$NAME.ly")"
WORK="$OUT/cache/audiveris"
mkdir -p "$WORK"

"$AUDIVERIS" -batch -export -output "$WORK" "$PDF"

MXL=$(find "$WORK" -maxdepth 2 -type f \( -name '*.mxl' -o -name '*.musicxml' -o -name '*.xml' \) | head -n 1)
if [[ -z "$MXL" ]]; then
  echo "Audiveris n'a produit aucun MusicXML dans $WORK" >&2
  exit 4
fi

"$MUSICXML2LY" -o "$OUT/$NAME.ly" "$MXL"

echo "Écrit : $OUT/$NAME.ly"
echo "À faire : adapter le .ly aux conventions KergallScore (includes, en-tête, voix, paroles)."
echo "Puis : \"$LILY\" -o \"$OUT/$NAME\" \"$OUT/$NAME.ly\""
