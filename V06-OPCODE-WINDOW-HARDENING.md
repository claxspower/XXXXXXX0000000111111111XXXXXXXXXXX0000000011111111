# GsXFuscator V0.6 — Prototype WindowGuard

This release keeps the visible `GsXFuscator V0.6` signature, VM9, SEAL4, automatic Fast Load for Sealed delivery, anime ASCII, and the existing web upload limits. It is a defensive obfuscator hardening update, not a guarantee against host-controlled debugging or devirtualization.

## What changed

The VM9 per-prototype opcode offset previously followed a quadratic function of the program counter. The new offset adds a window-dependent term:

```
window = 23 + (kb % 74)
shift  = 1 + (kc % md)
offset = (pc*pc*kc + pc*ka + kb + floor((pc-1)/window)*shift) % md
```

All four mixer words were already present in the artifact, so the new implementation does not expand the mixer metadata table or increase its per-instruction hash length. The expression is implemented consistently in the build-side encoder, the packed bytecode decoder (including lazy/self-modifying blocks), and the VM9 interpreter. The per-prototype mixer integrity checksum continues to cover all four values, with no new host-dependent API requirements.

This makes the on-wire opcode offset discontinuous at prototype-specific instruction boundaries instead of following one quadratic across the entire prototype. An analyst must handle the new mapping to associate a dumped instruction key with its registered handler. The mapping can still be recovered by an analyst with complete runtime control.

## Tests

- PUC Lua 5.4 `vm9_pipeline_proof.lua`: Strong direct+sealed, two seeds, VM9 packing round trip, authenticated tamper rejection, lazy and non-lazy prototypes: PASS.
- `v06_piecewise_opcode_regression.lua`: two seeds, lazy and regular execution, >190-statement program, and one coefficient mutation: PASS.
- `v06_safe_hook_smoke.py --lua /mnt/data/gsx_work_new/lua54`: 10 host/debug-hook scenarios: PASS.
- Web `python web/build.py`, `node --check public/compiler-worker.js`, `.tools/test_v07_artifact.js`, `.tools/test_v07_negative.js`: PASS.
- Original and new CLI outputs for the same 1,000-line input, seed 1729, strong/compact, Sealed and Direct: same program output `GSX_BENCH_1000 3986`.

### Size and speed (one host; low sample count)

| Mode | Old size | New size | Old median (4 samples) | New median (4 samples) |
|---|---:|---:|---:|---:|
| Strong Direct VM | 255,646 B | 255,577 B | 697 ms | 691 ms |
| Strong Sealed | 363,461 B | 363,628 B | 983 ms | 1,025 ms |

The apparent timing differences are not statistically meaningful with four samples and are not performance guarantees.

## Known limits

- The VM9 interpreter and its mapping still execute on an untrusted client. A tool such as Dex can reveal and simplify that client-side Lua. No client-side obfuscator can fully prevent this.
- The 32-bit build-derived container key and embedded integrity checks should not be represented as cryptographic secrecy against the artifact owner.
- Genuine Roblox/Luau, FiveM, and native Lua 5.1 were not exercised in this test run.
- The change improves one part of opcode analysis; it does not validate a 9.7/10 security score or prove superiority over MoonSec V3.
