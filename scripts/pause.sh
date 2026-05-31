#!/usr/bin/env bash
# Pausa el drop del día desde la compu (commit + push de un stub paused).
# Desde el celu, sin terminal: workflow "kill-switch" en la pestaña Actions de GitHub.
#
# Uso: ./scripts/pause.sh ["mensaje custom"]
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MSG="${1:-Hoy no hay drop — los algoritmos están durmiendo la siesta. Volvé en un rato.}"

if [ ! -f latest.json ]; then
  echo "pause: no hay latest.json" >&2; exit 1
fi

# Backup del Pool actual para poder despausar, y stub paused conservando date/edition/number.
cp latest.json latest.prepause.json
jq --arg msg "$MSG" \
  '{date, edition, number, status: "paused", pause_message: $msg, cards: []}' \
  latest.prepause.json > latest.json

git add latest.json latest.prepause.json
git commit -m "kill-switch: PAUSE ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
git push
echo "Pausado. La app va a mostrar PausedScreen con: $MSG" >&2
