**Update:** This is a historical measurement document. Current website and CLI always enable Fast Load for Sealed outputs; the website checkbox and CLI disabling option have been removed. Reference decoder is accessible only from internal tests.

# GsXFuscator V0.6 — Fast Load + Dex dump assessment

## Scope

This update is based on the previous **10 MiB / no application-level compile timeout** source release. The visible banner remains exactly:

```lua
--[[ This, File Protected By GsXFuscator V0.6 ]]
```

Strong VM9, SEAL4/SEAL2, integrity checks, the anime ASCII comment, and `.lua`, `.luau`, `.txt` uploads remain unchanged.

## Changes

1. **Fast Load for SEAL4 (enabled by default)**. The SEAL4 transport decoder processes four encoded symbols as three plaintext bytes, reducing `string.char` allocations. It also calculates each fragment's Adler-32 while the byte stream is being recovered and combines per-fragment Adler states instead of scanning that fragment again. Decoded length, alphabet validation, padding checks, both Adler checks and VM9 checks remain enabled. The reference implementation is still available with CLI `--no-fast-load`, or the website's **Fast Load** checkbox.
2. **Fragment-order tamper check**. The shuffled fragment-order metadata is checked against a compile-time positional rolling checksum. Duplicate indices, unknown fragment references and modified order are rejected before decoding. This is a **non-cryptographic consistency guard**, not authentication against an attacker able to patch the loader and expected value together.
3. **Web/CLI feature parity**. The browser Worker and CLI both accept the Fast Load setting; the website defaults to enabled. Luau-detected **Direct VM** artifacts bypass SEAL4, so the Fast Load switch has no effect on Direct VM startup.

## Supplied `dump(2).zip` and `envlog-dump.zip`

The archives contain essentially the same instrumented run. From the dump JSON metadata: `status=finished`, 1,589 recorded statements, 617,573-byte protected input, `elapsed_sec=48.60`, 2,419 string records, 174 instance records, 0 captured dynamic-load chunks, and 0 logged HTTP actions. Strings include many `table.concat` observations. The reconstructed trace exposes UI/Roblox behavior and constants such as `RickyCodeGui`, but **does not establish extraction of the original program source or full VM9 devirtualization**. Instrumentation of a host-controlled runtime can still observe behavior and plaintext constants as they are used. Fast Load and the ordering guard cannot make such runtime tracing impossible.

## Tests (local environment)

- Native Lua 5.4: 16 combinations of four synthetic fixtures, two seeds and Fast Load on/off passed.
- Strong + Sealed fixture: built and executed in Fast Load and reference modes; output matched.
- Same 1,000-line Lua source, seed 20261123: seven runs per mode, interleaved; median about **1,005 ms (reference)** and **953 ms (Fast Load)**. The 1,000-line Fast Load output was **359,827 bytes**, reference output **359,186 bytes** (641 bytes more; about +0.18%). This is one machine, one workload; results are not representative of Roblox/FiveM.
- Negative tests: changing a shuffled fragment index and changing a ciphertext character both produced `runtime verification failed`.
- Browser build: `python web/build12.py` succeeded; generated `compiler-worker.js` passed `node --check`.
- Browser-equivalent WebAssembly build via Node: Fast Load on/off both generated executable Lua output which produced the expected synthetic result.
- **Limitation:** Direct Chromium navigation was blocked by environment administrative policy. Real Roblox/Luau, FiveM and Lua 5.1 execution were not tested.

## Protection model

This is code obfuscation, anti-tamper and performance hardening, not a cryptographic trust boundary. Checksum metadata exists inside the output and cannot prevent a fully instrumented/controlled host from observing an application that runs on that host. No claim of undumpability or verified superiority over Luraph/MoonSec is made.
