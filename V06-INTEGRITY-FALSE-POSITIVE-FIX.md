# GsXFuscator V0.6 — Integrity false-positive compatibility fix

This update **keeps the product version at V0.6** and addresses a production error of the form:

```
GsXFuscator: integrity check failed
Script '', Line 43 - function _bad
```

**Diagnosis.** The generated `_bad()` function is the common failure target for many independent checks. A Roblox/Luau stack trace pointing to line 43 (after the anime comment) does not by itself identify the exact check. Static inspection found a concrete false-positive path: the 54+ Roblox API behaviour probes treated three differences in an API bridge / restricted host as tampering, regardless of whether the protected code was altered. Host debug-library and script-source heuristics could also terminate code on otherwise legitimate Luau hosts.

## Implemented

- An automatically detected host marker covers Luau (`_VERSION == "Luau"`) and Roblox (`typeof(game) == "Instance"`), with `pcall` around the detection. **There is no Target runtime UI selector.**
- On Roblox/Luau, environment-/debug-*heuristics* are advisory rather than fatal. The runtime still enforces VM bytecode/handler identity, opcode keystream anchors, packed payload validation, control-flow bounds, and per-prototype integrity.
- The 54+ host-API heuristic matrix is no longer enabled by default; it can be explicitly opted into for diagnostic experiments with the internal `Obfuscate.run(..., {strictHostChecks=true})` interface. This shrinks generated Lua and avoids slow, brittle API calls on production Roblox instances.
- Other Lua runtimes continue to receive the existing anti-debug checks. Real VM/payload tampering is fatal on all hosts.
- Existing output banner, anime ASCII artwork, compact single-line executable code, VM9, `.lua`/`.luau`/`.txt` drag-and-drop, and **V0.6** branding are preserved.

## Repro and tests

- Previously generated Direct VM with a partially proxied Roblox-shaped API: `integrity check failed`.
- Newly generated Direct and Sealed VM under the same simulated host: correct output.
- Native Lua 5.4: both output modes produce `GSX_TEST_2026 55 18`.
- Coupled H/HB opcode-handler substitution (an actual VM edit): **still rejected**.
- Existing V0.6 verifier security tests: pass.
- Chromium/Wasmoon compilation, `.txt` drop/pick/upload and resulting `.lua` download: pass.

## Limitations

This is a fix for a verified class of false positives, **not a guarantee that every Roblox/Luau environment will execute every Lua input**. A genuine Roblox client was not available for this test. The submitted traceback did not include the exact obfuscated script, so it cannot identify a unique failing check; additional host-specific failures may remain. Some compatibility heuristics are intentionally no longer treated as hard security barriers. Only data/code integrity checks continue to fail closed on Roblox/Luau. Re-obfuscate scripts after updating: old outputs retain their old error path.

Source regression: `v2/tests/v06_false_positive_fix.lua`.
