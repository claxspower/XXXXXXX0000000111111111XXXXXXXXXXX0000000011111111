# GsXFuscator V0.6 — Dead String Injection 2879
**Date:** 2026-11-23

## Delivered behavior
- Each final CLI/API (`src.artifact.build`) or web output, **Direct VM or Sealed**, receives **exactly 2,879 distinct string literals** injected by `v2/src/deadstrings.lua`.
- They are separate from the existing `src.strings` encrypted string-pool decoys and do not count towards them.
- The exact 2,879 generated literals are divided into 25 syntactically unreachable Lua `if false then local ...={...} end` blocks. They are not evaluated or allocated as tables during execution. The Lua parser still reads the literals.
- One insertion occurs **after** final delivery wrapping/branding, not once per internal VM prototype or source fragment.
- Visible `--[[ This, File Protected By GsXFuscator V0.6 ]]` header, original anime ASCII, and one-line executable code remain.
- Fast Load for Sealed is mandatory. The 10 MiB upload limit, other VM9, anti-tamper and SEAL4 behavior are unchanged.

## Reproducible checks
- Four seeds (1, 12345, 987654, 4294967295): 2,879 generated, 2,879 distinct; injected Lua syntax and runtime OK.
- CLI/API `Artifact.build` Strong Direct VM and Strong Sealed: both produced the expected program output (`42`), with exactly 2,879 injected literal entries.
- Web `v2driver.lua` Strong Direct VM and Sealed via Wasmoon: both compiled and executed (`GSX_WEB 42`), with 2,879 entries each.
- Direct and Sealed sample-input demos: both printed `GSX_TEST_2026 55 18`; code verified for 25 blocks and 2,879 distinct entries.
- Existing `test_v07.js`, `test_v07_negative.js`, and JS syntax check for `public/compiler-worker.js`: passed.
- Web HTML rebuild confirmed to include the newly compiled `src.deadstrings` module.
- Artifacts were zipped and ZIP CRC integrity verified.

## Cost and limits
- In both demo outputs, the dead branches add **114,967 printable characters** of source code (this is intentional and increases parse time and download size).
- An optimizer/deobfuscator can remove truly unreachable dead strings. Therefore, this feature is **obfuscation noise, not protection against full source recovery, cryptographic secrecy or a guarantee against dumping**.
- The tests use Wasmoon Lua 5.4, not real Roblox, FiveM, or Lua 5.1 execution environments.
- Manual browser UI interaction was not performed. The actual browser Lua driver was tested through Wasmoon.

## Files
- `v2/src/deadstrings.lua`: deterministic 2,879-entry generator and safe final-artifact insertion.
- `v2/src/artifact.lua`: CLI and API final-artifact integration.
- `web/v2driver.lua`: web direct/sealed/split-delivery integration.
- `web/build12.py`: bundle module registration.
- `.tools/test_deadstrings.js`, `.tools/test_deadstrings_web.js`: regression tests.
