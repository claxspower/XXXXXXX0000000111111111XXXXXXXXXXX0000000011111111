# GsXFuscator V0.6 — compact VM9 size optimization

**Scope:** V0.6 visible signature retained; strong, VM9, SEAL4 and existing runtime integrity logic retained. No claim of unbreakable obfuscation.

## Applied source changes

- `v2/src/vmgen.lua`: **live ISA pruning** in `VMGen.randomize`. The compact profile enumerates opcode names used by the compiled prototypes, keeps the original canonical order, and allocates randomized keys only for these live operations. The emitter generates the same protected handler implementation, aliases and operand masks for every retained operation, plus the unchanged 24 decoy slots. Emitted `stats.opcodes` now reports active opcode count and `stats.prunedOpcodes` the omitted count. `VMGen.OPCODES` remains the complete ISA catalogue size.
- `v2/src/vmgen.lua`: **compact runtime identifier generation** (5–6-character seeded identifiers for non-hot symbols). This only changes generated symbol names, not VM dispatch semantics or debug/integrity policy.
- `v2/src/obfuscate.lua`: enable both optimizations by default for `--vm-size compact` (already the default for CLI/web). `--vm-size standard` preserves the complete ISA-handler set and original identifier length. Optional Lua API `pruneHandlers=false` disables pruning for compact builds.
- `.tools/test_v07_negative.js`: repair a baseline-stale negative test to tamper with the actual SEAL4 mixed pool representation, not an obsolete local fragment layout. The mutation now provably triggers an integrity rejection.

## Same-source measurement (wasmoon Lua 5.4, seed 987654)

Input: `examples/bench_1000.lua`, 14,016 bytes, strong + compact, standard SEAL4 auto compression.

| Metric | Baseline (Dex Hardened) | This build | Difference |
|---|---:|---:|---:|
| Direct VM size | 295,263 bytes | 255,598 bytes | -39,665 bytes / -13.4% |
| Sealed size | 378,328 bytes | 361,484 bytes | -16,844 bytes / -4.5% |
| Live VM opcodes | 80 (full catalogue emitted) | 51 | 29 unused opcode families omitted |
| Aliases | 80 | 51 | Live opcodes still retain two randomized encodings each |
| Decoys | 24 | 24 | Unchanged |
| Source instructions | 8,423 | 8,423 | Unchanged |

Both Direct/Sealed programs printed `GSX_BENCH_1000 3986`. One-off execution samples were ~1.5s Direct, ~2.2–2.3s Sealed (including execution); **these are not stable speed benchmarks**.

## Other validation

- `examples/sample_input.lua` seed 12345: Direct and Sealed output `GSX_TEST_2026 55 18`.
- `examples/size_regression.lua`, seeds 42 and 779944: Direct/Sealed all output `GSX_REGRESSION 22 6 10` (closures, varargs, metatables, loops).
- SEAL4 fragment modified: rejected with `runtime verification failed`.
- `.tools/test_v07_artifact.js` and repaired `.tools/test_v07_negative.js`: passed.
- `python web/build.py`: generated refreshed Cloudflare Pages HTML and worker; `node --check` validated the worker syntax.

**Not completed:** Chromium navigation was blocked by administrator in this environment; therefore actual browser drag-and-drop was not independently verified here. The Lua 5.1 and real Roblox/FiveM runtimes were not tested. The old module8 long-running wasm suite timed out and is **not counted as a pass**. Very large (>300 KB) split-source memory/size regression not run.

**Security trade-off:** the compact profile omits handler implementations for ISA families the protected program does not use; this reduces the visible surface and file size, but a determined analyst may infer more about opcode coverage. Full-ISA `--vm-size standard` is still available for a larger, more redundant artifact. Neither mode is a cryptographic confidentiality boundary. VM9 and SEAL4 integrity tests do not prevent all runtime observation, remote HTTP `loadstring`, or devirtualization.

## Usage

```sh
lua v2/obfuscator.lua input.lua output.lua --preset strong --vm-size compact --seal
lua v2/obfuscator.lua input.lua output.lua --preset strong --vm-size standard --seal
```

Visible output header: `--[[ This, File Protected By GsXFuscator V0.6 ]]`.
