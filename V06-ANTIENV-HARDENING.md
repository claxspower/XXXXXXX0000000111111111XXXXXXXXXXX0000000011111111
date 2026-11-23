# GsXFuscator V0.6 — Capability-Gated Luau Anti-Environment Checks

**Date:** 2026-11-23. **Scope:** `v2/src/antidebug.lua`, `v2/src/vmgen.lua`, the existing WebAssembly browser build, and regression tests.

## Source assessment

The supplied Luau reference is a large environment-behavior test harness. It checks `debug.info` identity/metadata, Luau `table` APIs, buffer read/write, Roblox constructors and signals, and even version-sensitive `Path2D` floating-point values. Hardcoding its entire matrix into obfuscated code would be fragile. Different Roblox releases, legitimate executor wrappers, sandbox permissions and client contexts can diverge in ways unrelated to reverse engineering.

Four **behavior invariants** were integrated instead:

- `packx`: `table.pack('a', nil, 'z')` must preserve `n==3` and the nil gap.
- `freezex`: `table.freeze` / `table.isfrozen` must protect a freshly-created table from writing.
- `bufferx`: buffer `writeu16` / `readu16` must round-trip 48879 within a four-byte buffer.
- `infox`: `debug.info(luaFunction, 'f')` must preserve the exact function identity.

Probe families are selected with the existing per-build seed. **At least two of these four** are selected per build. Every probe is individually **capability-gated**: absent APIs and failed optional calls are treated as inconclusive, not inherently malicious. An executor host demotes the ambiguous or optional checks to avoid false positives; independent VM9 bytecode/handler integrity is not disabled.

The independent **periodic runtime primitive-identity snapshot** now also covers `table.pack`, `table.freeze`, `table.isfrozen` and the relevant `buffer` functions where the runtime offers them. It retains the existing executor-host compatibility gate for optional snapshots.

No Roblox or game instances are created, no global APIs are modified, no debug hook is forcibly installed by these new probes, and no unconditional startup warnings are added. A confirmed anti-debug score flows to the existing fail path and bounded GsxFuscator incident notice.

## Verified checks (Wasmoon Lua 5.4, not real Roblox)

- `test_antienv_luau.js`: healthy `packx`, `bufferx`, `infox`; malformed `packx`, `bufferx`, `freezex`, `infox`; absent API handling; 80 build seeds contain at least two Luau probes; Direct/Sealed execution with no warning.
- `test_antienv_runtime_negative.js`: actually generated protected Direct VM code detects a swapped `table.pack`, emits 256 bounded GsxFuscator warnings and halts before user code executes.
- Existing VM9 artifact, negative SEAL and mixed 10,000-dead-data tests remain compatible.
- WebAssembly web compiler and JavaScript syntax checked; embedded `src.antidebug` and `src.vmgen` should match these sources exactly.

## Limitations

This is a **bounded, best-effort anti-emulation and tamper-detection layer**, not a cryptographic trust boundary. A sufficiently accurate Luau emulator can implement these invariants. An attacker controlling the runtime can inspect VM handlers or extract plaintext during execution. The baseline uses ChaCha-like bytecode transport and keyed integrity layers; **this patch does not change the cipher, increase secret key entropy, add server-side secret storage or provide unbreakable encryption**. The correctness of these optional checks on live Roblox/Luau clients is **not yet measured**. Do not infer zero false positives on every executor from Lua 5.4 tests alone.
