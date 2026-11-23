# GsXFuscator V0.6 — 10 MiB input and no application compile timeout

- Upload cap: 10,485,760 UTF-8 bytes per `.lua`, `.luau`, or `.txt` source file (exact 10 MiB accepted; one extra byte rejected). The same check exists in browser UI and private Python service.
- Browser compilation: the former 120-second watchdog is removed. Worker failures, explicit cancellation when changing files, and genuine out-of-memory errors still surface.
- Private Python compiler: former 45-second subprocess timeout removed. Compiler memory and output ceilings remain unchanged.
- Cloudflare/API proxy: former 55-second AbortSignal timeout removed; request envelope limit is 64 MiB so JSON escaping of 10 MiB source can fit.
- 64 MiB is **not** the maximum source file size. Only 10 MiB source is accepted. The greater transport cap accommodates JSON escaping (for example `\u0000`).
- Host/Cloudflare, browser, operating system, or reverse proxy limitations cannot be disabled by site JavaScript. A 10 MiB file can be accepted but still fail to compile if it exhausts memory or output size.
- Build/test code timeouts remain intentionally present in test harnesses; these are not user-facing compile time limits.
- No changes to VM9, SEAL4, anime ASCII, `--[[ This, File Protected By GsXFuscator V0.6 ]]`, or output compression.
