# GsXFuscator V0.6 — Unified Lua + anime ASCII + smaller VM anchors

- **Version remains V0.6**. No target-runtime dropdown on the web UI; only `.lua` / `.luau` source files are offered.
- The browser infers Luau delivery for `.luau` or common Roblox-only source patterns, and emits Direct VM to avoid `load`/`loadstring`. Standard Lua defaults to Sealed VM; explicit CLI flags still work. This is heuristic, not an actual runtime detection guarantee.
- Original `v2/assets/anime_ascìì.txt` artwork is restored as a Lua **comment once at the top** of every emitted artifact. Actual VM/Sealed program body remains one line; the comment adds roughly 10 KiB and multiple header lines by design.
- The independent opcode-mixer snapshot now stores one rolling checksum per prototype instead of duplicating the four-word data table. The normal VM key schedule and periodic/preflight checks remain. This is unkeyed consistency checking, not a cryptographic trust boundary.
- The existing read-only anti-debug probes, anti-tamper, SEAL3 transport for ordinary Lua, and Strong + Compact VM defaults are retained. Aggressive `debug.sethook` installation is deliberately **not added**, to avoid legitimate profiler and Luau incompatibilities; `debug.gethook` checks already exist.
- `xxHash64` is a fast hash, not encryption. No user-side Lua obfuscator can promise to be unbreakable or guarantee protection against a host controlling execution.
- Large source payloads may still grow beyond 10 MB. The anime artwork is a fixed overhead only, not repeated per handler or payload block.

Run `python v2/tests/v06_unified_anime_smoke.py` from the package root for quick Lua 5.4 smoke verification. Existing tests expecting a totally one-line *file* need to be updated: only the executable payload is one line; visible art lines are comments.
