#!/usr/bin/env bash
# Crée un venv avec les dépendances du pipeline vectoriel.
set -euo pipefail
VENV=${VENV:-/tmp/pdftoly/venv}
python3 -m venv "$VENV"
"$VENV/bin/pip" install --upgrade pip
"$VENV/bin/pip" install pypdf fonttools pillow numpy
echo "venv prêt : $VENV"
echo "utiliser : PYTHON=$VENV/bin/python .opencode/skills/pdf-to-ly/scripts/py.sh ..."
