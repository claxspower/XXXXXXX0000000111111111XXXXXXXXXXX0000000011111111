# GsXFuscator V1.0 — Measured tests (2026-11-22)

## V1.0 source changes

- [CLAIR-GAP] Shuffled single sparse lookup pool mixing API objects, arithmetic encoded API keys and encoded SEAL4 payload fragments.
- [CLAIR-GAP] Version-diverse Lua 5.1-style arithmetic syntax used for name construction; every encoded name byte is an arithmetic expression.
- [CLAIR-GAP] `kb` rawget fallback supports `false` property values and metamethod fallback.
- [CLAIR-GAP] transient references cleared after payload recovery; no claim of guaranteed memory wiping.
- [CLAIR-GAP] existing controlled `debug.sethook` test preserved; no `fired > 3` invalid assumption.
- [CLAIR-GAP] single accurate, unbranded `runtime verification failed` error instead of fake random parser errors.
- [CLAIR-GAP] `--coroutine-wrap` CLI opt-in only, disabled by default because it changes coroutine execution. It does not block host dumps.
- [CLAIR-GAP] Existing VM9 remains inside Sealed mode. Mini-VM addition was intentionally unnecessary.

## Verified tests

- Native PUC Lua **5.4**: Strong VM Sealed and Direct VM, multiple build seeds, `--strict-verify` output equality (passed).
- Native PUC Lua **5.4**: `--coroutine-wrap` one-shot example (passed).
- Native PUC Lua **5.4**: SEAL4 payload byte tampering rejected; existing host debug hook preserved (passed).
- Chromium: `.txt` upload generated full V1.0 branded Sealed Lua via updated worker (passed).
- `node --check public/compiler-worker.js` passed.
- Lua **5.1**, Roblox/Luau and FiveM **not executed natively** in this environment; compatibility is not certified.

## 1,000-source-line performance benchmark

Input: exactly **1,000** nonempty Lua source lines (14,016 bytes, mostly arithmetic assignments). Strong + compact VM, seed 20261122. Ubuntu Linux container with liblua5.4; 3 internal timing runs; use only to compare this machine.

- Sealed V1.0 output: **378,250 bytes** (~27.0× source size).
- CLI verification and packaging: about **3.18 seconds** elapsed (`--strict-verify`).
- SEAL4 decoder factory compilation to loading the recovered inner source: **272 ms, 242 ms, 250 ms**. This includes fragment decode/checksums and is **not pure cipher time**.
- Full Sealed Lua CPU time (cold chunk load + execution): **1,161 ms, 1,140 ms, 1,153 ms**.
- Direct VM output: **297,992 bytes**, cold Lua CPU time **703 ms, 684 ms, 789 ms**.
- Earlier V0.6 baseline of same input: 377,643 bytes. Cold process wall time median ~1,040 ms vs V1.0 ~1,112 ms in separate runs. This is a small performance regression; no claim of speedup.

## Security and compatibility limitations

- `os.clock()` slot and embedded per-piece keys are not secret; the host can instrument `load` and inspect strings. Adler-32 is not a cryptographic MAC.
- Name arithmetic and pool shuffling raise basic static-analysis effort, not proof of resistance against Clair or Luraph.
- Debug hooks vary among runtimes. Existing host hooks are preserved to avoid recurring false-positive integrity errors.
- A wrapping coroutine changes yield behavior and does **not** prevent dumping Lua bytecode when the host controls execution.
- No meaningful security score or head-to-head claim is possible without controlled samples and deobfuscation results from competitors.
