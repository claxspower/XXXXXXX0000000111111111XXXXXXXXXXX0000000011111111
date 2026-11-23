# GsXFuscator V0.6 — 10 MiB upload / no application compile timeout

## Changes

- Browser accepts `.lua`, `.luau`, `.txt` up to **10 MiB = 10,485,760 bytes**. Exact boundary accepted, boundary + 1 rejected.
- Removed the **120-second** frontend watchdog for the browser compiler. Worker failure, file-change cancellation, and real errors are still handled.
- Removed the **45-second** Python compiler subprocess deadline.
- Removed the **55-second** `AbortSignal.timeout` proxy deadline.
- Increased authenticated API JSON transport cap from 8 MiB to **64 MiB** so that JSON escaping of 10 MiB of Lua UTF-8 source can fit. The source limit remains 10 MiB.
- Rebuilt bundled offline HTML, same-origin Worker, and embedded developer documentation.
- VM9/SEAL4 obfuscation machinery, V0.6 signature, anime banner, and protected output logic were not changed.

## Tests performed, 2026-11-22

| Test | Result |
|---|---|
| Web Worker JS syntax (`node --check`) | PASS |
| Cloudflare Pages API function JS syntax (`node --check`) | PASS |
| Python service syntax (`py_compile`) | PASS |
| Browser `.txt` drag-and-drop and compile | PASS; generated `.lua` 155,406 bytes |
| Browser file 10,485,760 bytes (selection boundary) | PASS |
| Browser file 10,485,761 bytes | Rejected as expected |
| Chromium **actual compilation** of 10,485,760-byte source, dominated by a Lua block comment | PASS; about 5.69 s, 62,684-byte output |
| Chromium actual compilation of 2,097,202-byte source, dominated by a Lua block comment | PASS; about 2.78 s, 62,909-byte output |
| HTTP service exact 10-MiB source with invalid rules | Received `400 Invalid build options`, confirming source was not rejected for size; test intentionally did not compile |
| HTTP service 10 MiB + 1 byte source | Received `400 The source exceeds 10 MiB.` |
| `.lua` / `.luau` / `.txt`, unsupported type, invalid UTF-8, empty source, download | PASS |

## Limitations

- These 10-MiB compile measurements used a source dominated by a **comment**; they do **not** establish successful compilation, speed, or memory usage for arbitrary 10-MiB application code.
- Browser and hosted services have platform memory/CPU/output constraints. In particular, existing `web/compile_job.py` output ceiling is **32 MiB**, and the Python Lua runtime has a memory cap. Hosting providers may impose their own deadlines that application code cannot remove.
- Browser watchdog removal means a genuinely stuck build will not automatically cancel. Selecting a different file or reloading terminates the old Worker.
- Native Lua 5.1 and Roblox/FiveM compatibility were not retested because obfuscated Lua generation was not changed.
