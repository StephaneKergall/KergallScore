#!/usr/bin/env bash
# Fast path pdf-to-ly : une seule commande pour diagnostic -> .ly -> PDF/MIDI.
# Usage : pipeline.sh <partition.pdf> [options de pipeline.py]
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
exec "$HERE/py.sh" "$HERE/pipeline.py" "$@"
