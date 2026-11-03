#!/usr/bin/env bash
# Crée (ou réutilise) un venv avec les dépendances du pipeline vectoriel.
# Idempotent : teste les imports avant d'installer, ne met pas pip à jour
# sauf --upgrade-pip. Options : --system-site-packages, --upgrade-pip.
set -euo pipefail
VENV=${VENV:-/tmp/pdftoly/venv}
PYTHON=${PYTHON:-python3}
SYSTEM_SITE=0
UPGRADE_PIP=0
for arg in "$@"; do
  case "$arg" in
    --system-site-packages) SYSTEM_SITE=1 ;;
    --upgrade-pip) UPGRADE_PIP=1 ;;
    -h|--help)
      echo "usage: setup_venv.sh [--system-site-packages] [--upgrade-pip]"
      exit 0
      ;;
    *) echo "option inconnue : $arg" >&2; exit 2 ;;
  esac
done

if [[ -x "$VENV/bin/python" ]]; then
  PY="$VENV/bin/python"
else
  VENV_ARGS=(-m venv)
  [[ "$SYSTEM_SITE" == 1 ]] && VENV_ARGS+=(--system-site-packages)
  "$PYTHON" "${VENV_ARGS[@]}" "$VENV"
  PY="$VENV/bin/python"
fi

if "$PY" -c 'import pypdf, fontTools' >/dev/null 2>&1; then
  touch "$VENV/.deps-ok"
  echo "venv déjà prêt : $VENV"
  echo "utiliser : PYTHON=$PY .opencode/skills/pdf-to-ly/scripts/py.sh ..."
  exit 0
fi

if [[ "$UPGRADE_PIP" == 1 ]]; then
  "$VENV/bin/pip" install --upgrade pip
fi
"$VENV/bin/pip" install pypdf fonttools
"$PY" -c 'import pypdf, fontTools' >/dev/null
touch "$VENV/.deps-ok"
echo "venv prêt : $VENV"
echo "utiliser : PYTHON=$PY .opencode/skills/pdf-to-ly/scripts/py.sh ..."
