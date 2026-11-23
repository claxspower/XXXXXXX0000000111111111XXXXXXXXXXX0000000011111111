# GsXFuscator V0.6 — Runtime string observation reduction

## Threat model: supplied dump.zip
- 5 members: `log.lua`, `dump.json`, `strings.txt`, `console.txt`, `original.lua`.
- The bot stopped after 0.077 seconds with `GsXFuscator: integrity check failed`.
- It recorded 93 strings in total: 90 from `table.concat`, and one each from `string.rep`, `string.format`, `string.sub`.
- `dump.json` contains 35 observed statements, no dumped executable chunks (`chunks: []`) and no recorded HTTP or file writes. The obfuscated input is included, not a recovered original source.
- These observations are from an emulated Roblox host and do not prove protection in every real-world host.

## Source changes
1. `v2/src/vmgen.lua`: the short API-name helper no longer submits decoded names to `table.concat`. It creates characters individually and joins with Lua `..`.
2. `v2/src/strings.lua`: the decrypted string pool now assembles decoded values with a balanced, pairwise Lua concatenation helper rather than passing plaintext to `table.concat`. Balanced joining prevents quadratic per-byte copying. This avoids the *observed* interception channel, not arbitrary inspection of the process or VM.
3. `v2/src/obfuscate.lua`: default compact profile does not emit optional environment-chaff global reads. The larger `standard` profile retains its historic decoys and module-level tests can still opt into them.
4. `v2/src/antidebug.lua`: a one-time, opt-in-by-capability active `debug.sethook` self-test is inserted after startup probes. It refuses to modify an existing hook, clears its own hook in `pcall`, treats unsupported APIs as inconclusive, and counts an unsuccessful self-test only as a weak corroborating signal. The simplistic `if _hooked then fail()` test is WRONG because a valid count hook should fire.
5. `v2/tests/v06_dump_channel_smoke.py`: reproducible `table.concat` observation regression for sealed and direct VM.

## Measured test, not security guarantee
Identical tiny Lua sample and seed (`20261122`, Direct VM), with a benign `table.concat` wrapper recording short string returns:
- Previous V0.6: 119 distinct captured strings; included `GSX_TEST_2026`.
- Updated V0.6: 1 captured string (`ab`); did not include `GSX_TEST_2026`.
- Updated Sealed: also 1 string from same observation method.
- Both still execute the sample and print `GSX_TEST_2026 55 18`.
This is a proof of improvement against ONE instrumentation method, not prevention of extraction by a controlled runtime. String values necessarily exist when supplied to external APIs or printed. An analyst controlling the VM/runtime can record them by other means.

## Requested performance/cache and clock observations
- Full startup anti-debug suite was already once-per-chunk; adding a broad cache does not eliminate repeated VM dispatch checks and would risk hiding post-load modifications. This update does not claim or implement a new per-function cache.
- The dynamic clock `slot` remains non-secret. A missing clock is a compatibility condition for restricted Lua/Luau hosts; forcing a hard fail by default would regress compatibility. NaN/infinite values are excluded by the existing validation but this cannot authenticate `os.clock()` against a fake runtime.
- Browser `.txt`, `.lua`, `.luau` drag-and-drop, anime ASCII, protected-by V0.6 banner, compact single-line executable body and Strong/compact VM defaults are retained.

## Test scope
- Native PUC Lua 5.4: Direct/Sealed strict verification, 2 clock values, tampered accumulator rejection, host environment separation and active hook rejection.
- Chromium local web compilation and TXT drag-and-drop checks passed.
- Luraph head-to-head challenge, native Roblox/Luau, and Lua 5.1-5.3 are not independently validated.
