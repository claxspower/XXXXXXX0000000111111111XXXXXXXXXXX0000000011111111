# V0.6 runtime refinement — findings and release checks

## Changes

1. Removed the obvious always-pass integer parity check. A runtime challenge now uses bytes recovered from all fragment checksums, fragment count, and the runtime clock slot.
2. `_clockSlot` is an active decoder argument; dynamically generated XOR nibble lookup table indices are permuted using it at runtime. This does **not** introduce a private key.
3. If `os.clock` is unavailable or returns an invalid number, the Sealed output rejects execution rather than falling back to a constant zero slot.
4. Checks basic `_G.print` presence and `_G` / environment coherence. It does not declare standard `debug.getinfo` a debugger by itself.
5. SEAL3's existing runtime decoder compilation, XOR + index shift + byte reversal, Adler32, hook and pcall/xpcall probes, and VM9 remain.
6. Output stays one-line token-minified and remains branded V0.6.

## Caveats

A runtime-dependent permutation used on both sides of a decoder is **obfuscation**, not a cryptographic secret. An attacker controlling Lua can intercept recovered strings and inspect the decoder. Adler32 is not a secure MAC. `os.clock`, `_G`, and debug API probes can cause compatibility failures on restricted sandboxes. No unbreakable opaque predicates or generic anti-debug protection is claimed.

## Verification completed

- Native Lua 5.4: strong Sealed and Direct under strict equivalence, with one-line output.
- 4-artifact V0.6 release smoke: passed.
- Negative checks: modified payload, existing debug hook, inconsistent `_G`, removed `os.clock` and removed `_G.print` rejected.
- Verifier-security regression checks: passed.
- Chromium build: Sealed and Direct compiled and ran through native Lua 5.4, producing the expected output.
- Native Lua 5.1–5.3 and additional hosts not retested; no claim of universal compatibility.
