#!/usr/bin/env bash
# Choisit un Python disposant de pypdf + fontTools, puis exécute le script.
set -euo pipefail
if [[ -n "${PYTHON:-}" ]]; then exec "$PYTHON" "$@"; fi
for p in /tmp/opencode/venv/bin/python /tmp/pdftoly/venv/bin/python; do
  if [[ -x "$p" ]] && "$p" -c 'import pypdf, fontTools' >/dev/null 2>&1; then
    exec "$p" "$@"
  fi
done
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
