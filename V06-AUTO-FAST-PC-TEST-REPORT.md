# GsXFuscator V0.6 — Auto Fast Load + PC Shield (test report)

## Implementation

1. Removed Fast Load option (including help row) from `web/v3template.html` and rebuilt `public/index.html` and `public/compiler-worker.js`.
2. Fast Load is mandatory for all Sealed builds from the web Worker, web driver, CLI and `Artifact.build`. Existing internal `Seal.wrap(...,{fastLoad=false})` reference decoder is retained strictly for A/B regression tests.
3. VM9 now uses a position-varying second mask on register-index operands `a,b,c`, on top of existing per-alias layout, sign and bias. The fourth immediate `d` is left exactly unchanged to preserve fractional/negative-zero semantics. The mask varies by alias and program counter and is reversed in the handler at runtime.
4. The VM9 pipeline regression was repaired: compact mode prunes unused opcode families, and seed-dependent flattening changes which families are used. The previous test incorrectly assumed both builds had exactly the same set of live opcodes. The revised test compares shared opcodes and still requires significant diversification.
5. No additional decoy/handler flood was added. This avoids inflating already-large outputs and preserves the compact VM profile.

## Execution / tamper / compilation evidence

- Lua 5.4, Strong/compact, synthetic fixtures: two seeds; Direct VM and Sealed; sample output `GSX_TEST_2026 55 18`; regression output `GSX_REGRESSION 22 6 10` — passed.
- Lua 5.4 Fast Load decoder regression (4 fixtures x 2 seeds x 2 decoder modes = 16 low-level reference comparisons): passed.
- `v06_pc_operand_mask.lua`: 17 compiled instructions checked for exact position-varying operand recovery, and reference mode tested: passed.
- `vm9_pipeline_proof.lua`: both modes, two seeds, 98 changed common opcode keys; authenticated packed-bytecode round trip; one-byte tamper and different-plan negative checks for regular and lazy/selfmod prototypes: passed.
- `.tools/test_v07_negative.js`: one-character modification of SEAL4 pool fragment rejected with `runtime verification failed`: passed.
- `v06_safe_hook_smoke.py`: 10 normal/profiler/missing/denied hook scenarios passed.
- `web/v2driver.lua` in Wasmoon/Node: `__FAST_LOAD=1` and `__FAST_LOAD=0` both generate byte-identical sealed output and it runs successfully on Lua 5.4; no user-facing off mode remains.
- `python web/build.py` and `node --check public/compiler-worker.js` passed. Output HTML contains no `fastLoadOpt` and no visible `Fast Load` controls.
- `--no-fast-load` on CLI is rejected with a clear diagnostic.
- The original 10 MiB upload check remains present. UI drag-and-drop and native Roblox/Luau/FiveM were not independently retested.

## Same-source A/B (strong, compact, seed 87654, 1000 lines, Lua 5.4)

| Metric | Previous Fast Load build | Auto Fast + PC mask build |
|---|---:|---:|
| Direct VM output size | 258,369 bytes | 265,403 bytes |
| Sealed output size | 364,618 bytes | 369,265 bytes |
| Direct VM runtime median | 671.75 ms | 692.8 ms |
| Sealed runtime median | 1011.95 ms | 979.6 ms |

Runtime measurements are **six executions per file**, interleaved/random order. They include whole-script execution and startup, and are noisy. PC masking adds work; do not claim a general speedup from these samples. New encoded output size grew approximately 2.7% (Direct) and 1.3% (Sealed). Fast Load was already active in the baseline so these are only the costs of the new PC-dependent mask, not a measure of Fast Load against reference decoder.

## Security scope and limitations

- The new mask introduces real per-instruction encoding variability; it is reversible by anyone able to analyze the whole interpreter and should **not** be described as encryption or a trust boundary.
- Existing handler/payload anti-tamper still detects the tested alterations, but a controlled host can inspect live calls and constants. It does not make Dex-style logging impossible.
- No controlled same-source benchmark against MoonSec V3, Luraph, IronBrew3 or other commercial tools was conducted. A security score of **9.7/10 is not verified** and should not be assigned as fact.
- The Fast Load SEAL4 decoder only applies to Sealed mode. Direct VM intentionally avoids that outer loader; it already has its own VM bytecode reader.
- The visible signature stays `--[[ This, File Protected By GsXFuscator V0.6 ]]` and the anime ASCII is preserved.
