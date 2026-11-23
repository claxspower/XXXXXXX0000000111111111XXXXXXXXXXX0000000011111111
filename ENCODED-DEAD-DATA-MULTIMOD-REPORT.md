# GsXFuscator V0.6 — Encoded Dead Data + Multi-Mod Operand Shield

Date: 2026-11-23

## Findings from the uploaded VS report

The supplied report evaluates the previous example at 9.2/10 **subjectively**; it
explicitly does **not** establish that GsXFuscator defeats MoonSec V3 or Luraph.
It notes that the 25 `if false` blocks and 2,879 dead strings are easy to remove
with constant-condition analysis, and that three VM aliases could draw a prototype
multiplier of 127 modulo 127, eliminating the intended prototype contribution.
This update addresses the latter correctness/diversity weakness. Encoded dead
strings address the user's specific output-format request only, **not** the
underlying devirtualization threat.

## Changes

- Preserve exactly 2,879 distinct existing dead strings in 25 inert blocks.
- Add 1,936 distinct inert encoded strings, distributed as 646 standard Base64,
  645 RFC 4648 Base32, and 645 RFC 1924 Base85, across 16 additional blocks.
  Total: 4,815 distinct dead literals per delivered output.
- Produce valid encoded text (20 unique input bytes per string, with a four-byte
  ordinal prefix). This is not an encrypted live payload, and it is never decoded
  or executed by the protected program.
- Keep no extra runtime tables from these branches; Lua source parsing still
  incurs a size/time penalty. They are removable by a competent optimizer.
- VM9 now selects among 24 prime moduli (127..251) per operand handler and
  chooses nonzero prototype multipliers strictly less than the modulus.
  Bytecode encoder and VM decoder both consume the same per-key plan, so their
  arithmetic stays symmetric. The change addresses disappearing prototype
  contributions without using a new key/trust boundary.
- Keep V0.6 visible banner + anime ASCII, single-line executable Lua,
  mandatory Sealed Fast Load, and the existing 10 MiB browser upload setting.

## Tests performed

1. **Dead-string and encoding round-trip**: 4 seeds (1, 12345, 987654,
   20261123) verify exact 2,879 + 1,936 counts and uniqueness; each emitted
   code string parses and runs in Wasmoon Lua 5.4. Node decoding checked
   all 1,936 values per seed, and Python standard library independently
   decoded all 1,936 generated values from the Direct demo.
2. **Artifact production**: Strong Direct and Strong Sealed (`noSeal=true/false`)
   each generated a working artifact containing all 4,815 dead strings;
   both printed `GSX_CODEC_RESULT 45`. Demo lengths: 324,562 B and 337,396 B.
3. **Actual browser Lua driver (under Wasmoon/Node, not Chromium)**:
   Direct and Sealed outputs each had 2,879 legacy + 1,936 coded decoys and
   printed `GSX_WEB 42`.
4. **Prototype salt structural test**: 128 independent seeds, 2,304 generated
   PC-dependent operand masks, 24 distinct selected prime moduli, and zero
   prototype multipliers divisible by their modulus.
5. **1,000-line runtime test**: Strong Direct 431,175 B and Strong Sealed
   541,432 B; both printed `GSX_BENCH_1000 3986`.
6. **Existing regression tests**: `.tools/test_deadstrings.js`,
   `.tools/test_v07.js`, `.tools/test_v07_artifact.js`,
   `.tools/test_v07_negative.js`, and repaired `.tools/test_deadstrings_web.js`
   passed. Payload mutation rejected with `runtime verification failed`.
7. **Web packaging**: `python web/build12.py` built `public/index.html` and
   `public/compiler-worker.js`; `node --check` passed. Embedded Lua module
   bytes match the new generator source.
8. ZIP CRC and SHA256 validation of distributed files: pass.

## Limits

A static compiler or deobfuscator can remove `if false` branches; all 4,815 dead
strings are obfuscation noise rather than proof of code confidentiality.
The new per-handler prime moduli are reversible and locally observable to an
analyst controlling the host environment. This is neither a cryptographic
trust boundary nor a guarantee of resistance to code reconstruction.
No real Roblox, FiveM, Lua 5.1-5.3 or Chromium browser execution was verified
in this run. Wasmoon Lua 5.4 and Node web-driver tests are not substitutes.
No controlled MoonSec V3/Luraph devirtualization benchmark was conducted;
claims of world's-best security would be unsupported.
