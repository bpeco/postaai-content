#!/usr/bin/env bash
# Despausa: restaura el último Pool bueno (latest.prepause.json) y lo pushea.
# Desde el celu: workflow "kill-switch" en Actions, opción unpause.
#
# Uso: ./scripts/unpause.sh
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f latest.prepause.json ]; then
  echo "unpause: no hay latest.prepause.json — nada que restaurar (¿ya estaba despausado?)" >&2
  exit 1
fi

cp latest.prepause.json latest.json
git add latest.json
git commit -m "kill-switch: UNPAUSE ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
git push
echo "Despausado — volvió el último Pool bueno." >&2
