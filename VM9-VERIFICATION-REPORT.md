# GsXFuscator V0.6 — VM9 pipeline and build-integrity report

Date: 2026-11-22. Visible protected-code signature remains `--[[ This, File Protected By GsXFuscator V0.6 ]]`.

## What changed

- Added `Bytecode.auditPacked(plan,payload)` to `v2/src/bytecode.lua`. It authenticates and fully decodes the packed VM9 bytes **during the build**, then compares restored prototypes to the intended compilation plan. It checks flags, constants, upvalues, regular instruction keys/operands, and encrypted lazy/self-modifying instruction blocks. The build refuses to emit on a mismatch.
- `v2/src/obfuscate.lua` now requires this audit for every VM9 build and exposes `vmLayerVerified=true`, plus `stats.vmAudit` with the validated counts. The audit metadata is build-side only and does not leak into protected Lua output.
- Added a synthetic regression `v2/tests/vm9_pipeline_proof.lua` covering two seeds, Strong Direct VM and Sealed, normal and self-modifying bytecode, tampering, a wrong-plan check and no plaintext fixture marker in output.
- Updated the old `v05_loader_dump_lab.lua` to examine **all** observed `load()` chunks: SEAL4 presently compiles a 657-byte decoder factory, an inner SEAL2 loader, and a larger VM9 Lua interpreter. Old tests incorrectly assumed the first `load()` was the VM.
- Fixed two stale tests to honor the existing V0.6 visible signature and to allow intentional newlines in the comment-only anime ASCII. The executable segment remains one line.

## Existing protections verified, not invented here

The previous source already implemented VM9 opcode-key randomization, multiple handler aliases, operand permutations/masks, per-prototype opcode keystreams, packed ChaCha20 container encoding, SipHash trailer, handler pinning and runtime checks. This update **verifies** these properties and adds a new build-time round-trip integrity gate; it does not replace the runtime architecture or implement brand-new opcode or handler diversification.

## Tests (local Lua 5.4 test runner; trusted project fixtures)

| Test | Result |
|---|---|
| `v2/tests/vm9_pipeline_proof.lua` (2 seeds, Strong direct+sealed) | PASS |
| Opcode keys for 2 seeds | 160/160 changed; handler identifiers changed |
| Self-modifying / regular VM9 pack-unpack checks | PASS |
| Modified ciphertext, mismatched plan | Both rejected |
| `v2/tests/v06_state_machine_smoke.py` | 4 builds PASS; 2 SEAL4 payload changes rejected |
| `v2/tests/v05_full_anchor_regression.lua` | Both live-handler/decoy mutations rejected |
| `v2/tests/v05_loader_dump_lab.lua` | Runtime host observed VM interpreter source, **not original source** |
| `v2/tests/v102_luau_bypass_regression.lua` | Three test scenarios PASS |
| `v2/tests/v06_seal3_browser_smoke.py` | Chromium compiler PASS |
| Direct VM execution with host `load()` wrapper | 0 runtime load calls for a simple fixture |

## Performance (same 1,000-line sample, Strong preset, seed 1789)

| Measure | Previous engine | Verified engine |
|---|---:|---:|
| Sealed file | 379,967 bytes | 379,967 bytes |
| Direct VM file | 295,392 bytes | 295,392 bytes |
| Sealed strict-build wall time (single run) | 3,045 ms | 3,379 ms |
| Direct strict-build wall time (single run) | 2,099 ms | 1,911 ms |
| Sealed runtime median (3 new processes) | 964.5 ms | 971.7 ms |
| Direct VM runtime median (3 new processes) | 706.7 ms | 726.6 ms |

Same-seed outputs before/after the audit are **byte-for-byte identical**. Therefore the new audit adds **no instructions or runtime work**; differences between the three-run timings are measurement noise, not proof of a new performance gain. Build audit has work at compile time and can add some overhead; the isolated build measurements are too few to characterize it reliably.

## What the evidence does and does not prove

- The Strong path compiles source into VM9 and stores VM instructions/constants in encrypted, integrity-checked VM bytecode. Sealed wraps the **VM Lua interpreter**, not the user's original plaintext script. Direct VM omits the outer dynamic loader.
- Sealed mode is **observable by a host with control over `load`/`loadstring`**. In one local test a hook captured three generated chunks, including 311,217 bytes of VM interpreter source; none equaled the original input. This limits confidentiality and must not be described as undumpable.
- Build-seed-derived keys are included with client-shipped code. SipHash, ChaCha20, anti-debug, and checksum checks do not establish a secret trusted execution boundary on an attacker-controlled host.
- No authenticated third-party Luraph/Clair samples were benchmarked in this update, so superiority claims and numerical resistance scores cannot be justified.
- Not tested on native Lua 5.1, Roblox/Luau, or FiveM. Only local Lua 5.4 and Chromium output generation were directly exercised.

## Reproduce

From project root, with your Lua 5.4 executable at `$LUA`:

```sh
$LUA v2/tests/vm9_pipeline_proof.lua
GSX_LUA=$LUA python3 v2/tests/v06_state_machine_smoke.py
LUA_PATH='v2/?.lua;v2/?/init.lua;;' $LUA v2/tests/v05_full_anchor_regression.lua
LUA_PATH='v2/?.lua;v2/?/init.lua;;' $LUA v2/tests/v05_loader_dump_lab.lua
python3 web/build.py
python3 v2/tests/v06_seal3_browser_smoke.py
```
