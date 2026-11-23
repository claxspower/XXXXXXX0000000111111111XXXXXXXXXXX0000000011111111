# GsXFuscator V0.6 — normal Execute: no false warning spam (2026-11-23)

## Root cause

The Mixed10K carrier in `v2/src/deadstrings.lua` inserted `earlyNotice()` **unconditionally** into every delivered Lua artifact. In any Luau runtime with `warn`, it printed the GsxFuscator incident message **16 times even when no debugger, tamper, or dump attempt existed**. This matches the user's Potassium executor screenshot showing a cluster of warnings on a normal `Execute`.

## Code change

- Deleted `earlyNotice()` and removed its unconditional call from `DeadStrings.inject`.
- Kept 10,000 seeded mixed inert strings and all original VM9/SEAL2/SEAL4 integrity logic.
- Kept `src.clax_alert` **only for actual failures in existing VM9, SEAL2 and SEAL4 guard paths**, with the existing bounded incident limit of 256 messages; it then stops execution.
- Updated `test_mixed10k.js` and `v06_proto_metadata_guard_regression.lua` to require **zero** warnings on clean code.
- Added `v06_no_startup_warn_regression.lua`, covering Direct/Sealed on a plain Lua 5.4 host and on a **simulated** executor API surface (`getgenv`, `gethui`, `identifyexecutor`). This simulator does not replace tests in real Roblox/Luau/Potassium.

## Verification

- Clean Direct and Sealed under Lua 5.4: **0 warning calls**, correct output; also 0 under simulated executor-global API presence.
- Four corruption scenarios: bytecode invalid transport, opcode mixer corruption, SEAL4 manifest alteration, SEAL2 length alteration: each **256 warning calls then rejected**.
- Proto metadata corruption: **256 warning calls and rejected**, while clean metadata emits 0 warnings.
- Three seeds × 10,000 mixed decoys: exact counts and unique literals retained.
- Browser build pipeline and WebAssembly driver Direct/Sealed output: compiled and ran (not actual Potassium navigation).

## Limitations

A permissive executor's own hooks and APIs are not evidence of tampering. It is not possible to guarantee zero false alarms across all Roblox executors without running real-world compatibility tests. Also, client-side Lua protection does not prevent passive API logging by a fully controlled host. Incident warning volume is diagnostic and does not itself protect code.
