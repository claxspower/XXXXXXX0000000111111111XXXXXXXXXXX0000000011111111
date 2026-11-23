# GsXFuscator V0.6 — Prototype Metadata Guard / Dex Stage Matrix

Date: 2026-11-23

## What the screenshots actually demonstrate

Three Dex Bot screenshots report successful job completion. One claims 32 virtual prototypes, 115 strings, and 99 numbers. A second reports a threaded environment/trace dump in 0.9 s. A third reports Luraph-specific VM lifting in 2.6 s. Those are the bot's self-reported processing results, **not** independent proof that GsXFuscator's original source was completely recovered. The screenshots contain no source code or proof of successful semantic reconstruction.

## New defensive improvement

New checks in `v2/src/vmgen.lua` and `v2/src/integrity.lua` commit each VM prototype's parameter count, vararg flag, number of upvalue descriptors, and each descriptor's flag/index to an independent build-time checksum. The live decoded metadata is checked **before function entry**, **before VM CLOSURE captures upvalues**, and during the existing periodic VM integrity audit (all prototypes on the first checkpoint; rotating thereafter).

This reduces the window for modifying prototype metadata after unpacking and before execution. Importantly, it does *not* prevent an observer from reading metadata or logging Roblox API calls. A fully hostile host can instrument VM execution or patch its integrity checks, so this is not a cryptographic guarantee.

The existing opcode/operand/window masks, dispatch-bank diversification, Base-91 canonical validation, SEAL4 verification, and bounded 100-warning response remain enabled. The warning is emitted for **verified integrity failures**, not merely because a tool claims to be running.

## Evidence and test outcomes

* 24/24 Strong-protected samples (12 Lua semantic families x Direct VM / Sealed) matched the original expected output on native Lua 5.4.
* Two independent seeds (12345 and 868686) produced correct Direct/Sealed output for a nested-closure program: `GSX\\\_METADATA 42`.
* An injected *post-unpack* prototype parameter mutation triggered `runtime verification failed` and exactly 100 `GsxFuscator` warnings; unchanged scripts triggered zero warnings.
* `v06\\\_clax\\\_incident\\\_regression.lua`: PASS — corrupt VM metadata, invalid transport, reordered SEAL4 manifest, and corrupted SEAL2 header.
* `v06\\\_dispatch\\\_bank\\\_regression.lua`: PASS — six variants.
* `v06\\\_transport\\\_canonical\\\_regression.lua`: PASS — four invalid-transport cases.
* `v06\\\_proto\\\_metadata\\\_guard\\\_regression.lua`: PASS.
* `.tools/test\\\_v07.js`, `.tools/test\\\_v07\\\_artifact.js`, `.tools/test\\\_v07\\\_negative.js`: PASS.
* WebAssembly / bundled web-side Lua engine: produced both Direct VM and Sealed outputs; both printed `WASM\\\_PROTO 42` on native Lua 5.4. The web source includes the modified `vmgen.lua` and `integrity.lua`. This is **not** a full browser interaction or Roblox test.
* `node --check public/compiler-worker.js`: PASS.

## Same-source size comparison

Source: `examples/bench\\\_1000.lua` (seed 987654, Strong, Compact):

|Delivery|Before|After|Change|
|-|-:|-:|-:|
|Direct VM|255,164 bytes|255,549 bytes|+385 (+0.15%)|
|Sealed|364,946 bytes|365,730 bytes|+784 (+0.21%)|

Both returned `GSX\\\_BENCH\\\_1000 3986`. A single compilation-time observation was taken per variant and is not sufficient to claim a speed increase or decrease.

## Boundaries / recommended deployment

* **Sandbox/environment hooks:** callbacks and external APIs can be logged by a controlling host with no in-program modification. Detection is heuristic and can have false positives. None of the listed screenshots proves all the original Lua code was recovered.
* **VM lifting / reconstructing prototypes:** changing live closure metadata is now checked. Read-only extraction, or a modified interpreter that suppresses checks, is not absolutely preventable.
* **Proprietary secrets:** put authorization, purchase checks, tokens, server-trusted game logic, and sensitive algorithms on a trusted server, not in a client-distributed Lua chunk.
* **Compatibility:** native Lua 5.4 and Wasmoon covered; Lua 5.1–5.3, Roblox Studio, FiveM and real Dex tools were not executed end-to-end here. Do not claim a score of 9.7/10 or invulnerability without independent attacks and runtime testing.

The visible header remains `--\\\[\\\[ This, File Protected By GsXFuscator V0.6 ]]`. Fast Load is automatic for Sealed outputs. Web file-upload limit is still 10 MiB. The existing incident message begins with `GsxFuscator`.

