# GsXFuscator V0.6 — AdaptiveVM + Prototype Shield

## What's actually implemented

- **Adaptive VM9 alias allocation (Strong/Compact default):** Each live opcode gets at least one full handler, then a capped pool of extra aliases is allocated preferentially to frequently emitted opcode families. The previous two-identical-budget-aliases-per-opcode scheme is retained for `vmSize=standard` or internal reference tests (`adaptiveAliases=false`). No bytecode instruction or integrity check is removed. The update changes the *distribution and number of real handler bodies*, rather than inflating the VM with inert decoys.
- **Prototype-salted operand encoding:** The existing per-alias per-PC operand mask now also incorporates the prototype index and a key-local per-build salt. The salt is encoded and reversed consistently in all nested VM frames. Floating-point immediate `d`, including negative zero, is preserved byte-exactly. This is reversible obfuscation, not cryptographic secrecy.
- Existing VM9, bytecode authenticity/audit, PC-dependent opcode mask, SEAL4, Fast Load by default, V0.6 signature, anime ASCII, single-line runnable chunk, 10 MiB browser upload limit, and hidden Fast Load UI control are retained.

## Controlled A/B — exact same source, seed=87654, Strong/Compact, PUC Lua 5.4

The source is `examples/bench_1000.lua` (1000-line synthetic arithmetic fixture). Baseline is the previously delivered `AutoFast_PCShield` full-source ZIP. Each artifact is compiled in the same environment and run five times. Runtime includes the entire program, not merely payload loading. Repeated runs are noisy.

| Mode | Previous size | AdaptiveVM size | Difference | Previous median | New median |
| --- | ---: | ---: | ---: | ---: | ---: |
| Direct VM | 265,403 bytes | 256,967 bytes | -3.18% | 692.79 ms | 711.08 ms |
| Sealed + Fast Load | 369,683 bytes | 365,318 bytes | -1.18% | 1009.36 ms | 1008.33 ms |

Both artifacts printed `GSX_BENCH_1000 3986`. The small Direct VM slowdown is not hidden; five measurements do not justify a claim of significant slower/faster general behavior.

## Tests executed and outcomes

- `v2/tests/v06_adaptive_protosalt.lua`: PASS (8 opcode families, 12 allocated aliases vs 16 baseline, 38 operand round trips, authenticated packed-bytecode audit and one-byte ciphertext tamper rejection).
- `v2/tests/v06_pc_operand_mask.lua`: PASS (17 instruction masks verified, reference mask-disabled path).
- `v2/tests/vm9_pipeline_proof.lua`: PASS (Strong Direct+Sealed for 2 seeds; diversified handler keys; verified VM9 packing and negative tests, including lazy/selfmod prototypes).
- `v2/tests/v06_safe_hook_smoke.py`: PASS (10 hook/profiler/denied scenarios, Sealed and Direct).
- Node Wasmoon `.tools/test_v07_artifact.js`: PASS (web-compatible Lua/WebAssembly Sealed compilation and execution).
- Node Wasmoon `.tools/test_v07_negative.js`: PASS (modified SEAL4 ciphertext rejected with `runtime verification failed`).
- `python web/build.py` and `node --check public/compiler-worker.js`: PASS. Confirmed new `vmgen.lua` and `obfuscate.lua` source hashes match embedded Base64 modules in generated HTML. Fast Load checkbox absent, existing 10 MiB constraint present.
- ZIP checks: full source and Cloudflare Pages each pass `ZipFile.testzip()`.

## Security interpretation

- The latest DeepSeek report (`Yapıştırılan metin(20261122-215717).txt`) estimates MoonSec V3 slightly ahead in static control-flow complexity and considerably ahead in output compactness. This change addresses two actual GsXFuscator costs and diversifies operand encoding, but **does not prove a victory over MoonSec V3 or a 9.7/10 protection score**.
- No matched-original-source benchmark against MoonSec V3, no independently validated devirtualization resistance test, no native Lua 5.1/Roblox/Luau/FiveM runtime verification were completed here.
- A fully controlled host can still observe live VM execution and decoded values. Opcode/operand masks and obfuscation are not cryptographic trust boundaries. API hooks and instrumented runtimes can still log application behavior.
- Don't assume anti-tamper won't false-positive on every host. Preserve tests for denied debug APIs and live profiler hooks.
