# postaai-content

Pool JSON publicados por el pipeline de [PostaAI](https://github.com/bpeco/) (motor en `ai-digest/`).

## Layout

- `latest.json` — Pool más reciente. La app iOS lo fetchea desde este path. Cache-Control: `public, max-age=60`.
- `archive/YYYY-MM-DD-{morning,evening}.json` — histórico inmutable. Cache-Control: `public, max-age=31536000, immutable`.

## Cómo se publica

El cron de GitHub Actions vive en el repo de código (`bpeco/postaai`, workflow `digest`), corre 2x/día (09:00 / 18:00 ART) en modo `--pool-only`, genera el Pool y lo pushea acá vía la fase 10 (`ai-digest/scripts/publish-pool.sh`). Vercel deploya automáticamente cuando aparece un commit nuevo.

> El mismo pipeline también corre local en la Mac de Bauti vía launchd, pero eso se apaga cuando el cron en la nube queda validado (sino se duplican drops).

## Kill switch

**Desde el celu (sin git, sin terminal):** pestaña **Actions** → workflow **kill-switch** → **Run workflow** → elegí `pause` o `unpause`.
- `pause` guarda el Pool actual en `latest.prepause.json` y escribe un stub `{status:"paused", pause_message, cards:[]}` → la app muestra `PausedScreen`.
- `unpause` restaura el último Pool bueno desde `latest.prepause.json`.

**Desde la compu:** `./scripts/pause.sh ["mensaje custom"]` y `./scripts/unpause.sh`.

> Ojo: un `pause` dura, como mucho, hasta la próxima edición — el siguiente run del cron sobreescribe `latest.json` con un Pool fresco. `unpause` es para volver al Pool bueno **ya**.
