# GsXFuscator V0.6 — Dispatch-Bank Validation Report

## Scope
This update modifies the VM9 backend (`v2/src/vmgen.lua`) by introducing prototype-and-window-dependent, reversible dispatch-bank remapping. The physical handler table remains part of the executable artifact; the mapping is not a cryptographic secret. The current mapping builds a bijection between original handler slots and dispatch slots for each prototype and PC window. Frame-invariant terms are cached once per prototype call, while the PC window and polynomial opcode mask are calculated per instruction. The same transform is used for normal and self-modifying bytecode.

The release retains the exact visible signature `--[[ This, File Protected By GsXFuscator V0.6 ]]`, anime ASCII, VM9, SEAL4, automatic Fast Load, the 10 MiB upload cap, no intentional application compilation timeouts, and `.lua`/`.luau`/`.txt` upload support.

## Authentic test corpus (>700 files)
- 12 independent Lua behavior families, with 32 deterministic programs per family: **384 sources**, plus **384 corresponding expected stdout files**, and a JSON manifest.
- Families include numeric-for loops, while/repeat loops, upvalues, nested closures, string library, nested tables, varargs, multiple returns, metatables, arithmetic, conditionals and array sorting.
- All 384 sources were executed successfully using a local PUC Lua 5.4 binary and matched their golden stdout files.
- One representative program per family (12 cases) was compiled in both Strong Direct and Strong Sealed modes; **24/24 protected artifacts** executed under local Lua 5.4 and exactly matched the expected stdout.
- The corpus is deliberately real data for regression tests, not filler to make a large archive.

## Other tests
- `v2/tests/v06_dispatch_bank_regression.lua`: **6 variants passed** across two seeds / direct-and-packed / normal-and-selfmod combinations.
- `v2/tests/v06_piecewise_opcode_regression.lua`: **4 valid cases passed** and modified opcode coefficients rejected.
- `v2/tests/v06_adaptive_protosalt.lua`: **passed**.
- `v2/tests/v06_fastload_regression.lua`: **16 variants passed**.
- `v2/tests/vm9_pipeline_proof.lua`: VM9 Strong Direct+Sealed at two seeds, authenticated round trips and negative audits **passed**.
- Web build `python web/build.py`, JavaScript syntax check, and exact embedded-VM-source comparison **passed**.
- Node/Wasmoon web compiler produced Strong Direct+Sealed examples, both ran correctly on Lua 5.4: `GSX_TEST_2026 55 18`. This is not equivalent to a live browser or Roblox test.
- All ZIP archives have been checked for CRC errors, plus SHA-256 digests.

## Byte size and timing comparison
The baseline is the immediately previous V0.6 WindowGuard build, with the **same** 1,000-statement synthetic source, seed 8151, Strong Compact profile, Lua 5.4:

| Mode | Baseline bytes | New bytes | Change |
|---|---:|---:|---:|
| Direct VM | 254,248 | 254,897 | +649 (+0.26%) |
| Sealed | 364,914 | 365,568 | +654 (+0.18%) |

One four-run native process sample (medians; end-to-end): Direct baseline **783.6 ms** vs new **755.1 ms**; Sealed baseline **1011.0 ms** vs new **1058.4 ms**. These very small samples show variance; **no general speed improvement is claimed**.

## Security limits
The new dispatch-bank makes naïve static opcode-to-handler inference less direct, but it is still reconstructed from code and data available at runtime, and a sufficiently powerful dynamic analyst can inspect interpreter state. This is **not** encryption, a sandbox, an anti-cheat boundary or a guarantee against dumping, disassembly, devirtualization, Dex or MoonSec V3. No independent devirtualization benchmark against MoonSec or Luraph was performed.

Native PUC Lua 5.1, live Luau/Roblox/FiveM and a real end-user Chromium browser were not tested here. Do not infer compatibility from the Lua 5.4 or Node/Wasmoon passes.

## Use
To reproduce generator regression tests from the full-source root: `/path/to/lua54 v2/tests/v06_dispatch_bank_regression.lua`, `/path/to/lua54 v2/tests/vm9_pipeline_proof.lua`. Golden files live under `v2/tests/semantic_corpus/`.
