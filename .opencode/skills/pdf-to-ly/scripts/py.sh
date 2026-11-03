#!/usr/bin/env bash
# Choisit un Python disposant de pypdf + fontTools, puis exécute le script.
# Rapide : un seul interpréteur testé, résultat mémorisé par un stamp.
set -euo pipefail
if [[ -n "${PYTHON:-}" ]]; then exec "$PYTHON" "$@"; fi

VENV=${VENV:-/tmp/pdftoly/venv}
VENV_PY=${PDFTOLY_PYTHON:-$VENV/bin/python}
STAMP="$VENV/.deps-ok"

if [[ -x "$VENV_PY" ]]; then
  if [[ -f "$STAMP" ]]; then
    exec "$VENV_PY" "$@"
  fi
  if "$VENV_PY" -c 'import pypdf, fontTools' >/dev/null 2>&1; then
    touch "$STAMP" 2>/dev/null || true
    exec "$VENV_PY" "$@"
  fi
fi

# Ancien emplacement, conservé pour compatibilité.
LEGACY=/tmp/opencode/venv/bin/python
if [[ -x "$LEGACY" ]] && "$LEGACY" -c 'import pypdf, fontTools' >/dev/null 2>&1; then
  exec "$LEGACY" "$@"
fi

if python3 -c 'import pypdf, fontTools' >/dev/null 2>&1; then
  exec python3 "$@"
fi

cat >&2 <<'EOF'
pypdf et fontTools sont absents. Crée un venv :
  .opencode/skills/pdf-to-ly/scripts/setup_venv.sh
puis relance avec :
  PYTHON=/tmp/pdftoly/venv/bin/python .opencode/skills/pdf-to-ly/scripts/py.sh ...
EOF
exit 2
