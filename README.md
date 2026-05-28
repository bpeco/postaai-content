# postaai-content

Pool JSON publicados por el pipeline de [PostaAI](https://github.com/bpeco/) (motor en `ai-digest/`).

## Layout

- `latest.json` — Pool más reciente. La app iOS lo fetchea desde este path. Cache-Control: `public, max-age=60`.
- `archive/YYYY-MM-DD-{morning,evening}.json` — histórico inmutable. Cache-Control: `public, max-age=31536000, immutable`.

## Cómo se publica

El script `ai-digest/scripts/publish-pool.sh` (en el repo principal) corre como fase 10 del pipeline 2x/día y hace `cp` + `git commit/push` acá. Vercel deploya automáticamente cuando aparece un commit nuevo.

## Kill switch (manual, sin tipear git crudo)

Para pausar el drop del día desde el celu: editar `latest.json`, cambiar `"status": "published"` por `"status": "paused"` y agregar `"pause_message": "..."`. Push. La app renderea `PausedScreen` con ese mensaje.

Para revertir: `git revert HEAD && git push` (o reemplazar `latest.json` por uno del `archive/`).
