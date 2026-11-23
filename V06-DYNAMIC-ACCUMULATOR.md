# GsXFuscator V0.6 — Dynamic integrity accumulator update

## Change

- The startup anti-debug probe-shape accumulator is now an order-sensitive polynomial recurrence modulo 1,000,003. Every probe contributes a separate token and a runtime-clock-slot term. The old static `sum` equality no longer appears in new Direct VM builds.
- Runtime slot is derived from `os.clock()` if available, finite and plausible; a missing/invalid clock does not *by itself* cause a false-positive in this separate startup shape check. (The pre-existing SEAL3 loader still has its own runtime clock requirement.)
- The expected accumulator is computed as an expression from two build-time coefficients and the live slot. This is a runtime-dependent tamper *check*, not a cryptographic secret or proof of unbreakability.
- Existing performance strategy is preserved: startup probes run once on load. Primitive references are captured once, and later changes are checked on scheduled integrity ticks instead of running the entire startup probe suite on each VM instruction. The code intentionally does not cache later reads across ticks, which would miss post-load tampering. No new result-cache was needed or added.
- Existing V0.6 branding, anime ASCII, compact single-line executable body, `.lua` / `.luau` / `.txt` upload and drag-and-drop are retained. The runtime-target dropdown is still absent.

## Evidence

- Native Lua 5.4: sealed and direct-vm strict verification, two clock values, accumulator mutation rejection.
- Runtime regression: active debug hook, corrupted transport, separate `_G` environment, missing sealed clock.
- Browser Chromium: both delivery modes generated, `.txt` drag-and-drop produced a `.lua` download, invalid/too-large files rejected.
- Four-artifact seed and delivery matrix passed with CLI strict verification.
- Size on a fixed tiny input and seed: previous sealed 184,481 bytes; dynamic-check sealed 185,031 bytes (+550 bytes). The new condition has a small size cost; this is not a compression upgrade.

## Limitations

- A clock value is not a secret. An attacker controlling the Lua runtime can observe or fake it, and can patch a local program. Dynamic checks increase work but do not establish a cryptographic trust boundary.
- This is not a verified `8/10` or `Luraph` parity rating. No independent deobfuscation challenge was run.
- Roblox/Luau execution and Lua 5.1–5.3 compatibility are not verified in this change; tested engine is native Lua 5.4 and browser Lua worker.
- Large Lua source code can still create large artifacts. Only the generated executable body is one line; the anime ASCII is a multi-line comment header.

## Review files

The complete `.lua` artifacts are available separately. The `Review_Parts.zip` contains the **direct VM** artifact split into UTF-8-safe text parts for inspection. Individual parts are not valid Lua. Concatenate their bytes in order to recreate the exact whole file.
