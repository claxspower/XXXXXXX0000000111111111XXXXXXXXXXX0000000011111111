# GsXFuscator V0.6 — SEAL3 false-positive repair

## Why `Line 43 - function _bad` kept appearing

The anime artwork puts executable Lua on line 43. In a **sealed** output the
named `_bad()` error function belongs to the *outer SEAL3 transport*, not to
the inner VM9 dispatcher. The previous Roblox/host compatibility hotfix was
focused on VM9 and could not fix SEAL3's independent checks.

The SEAL3 loader was treating normal runtime differences as payload corruption:

- active `debug.gethook()` returned by a profiler/host;
- `debug.getinfo()` reporting different metadata;
- `pcall`/`xpcall` error-message wrapping;
- non-monotonic or stubbed `os.clock`/`os.time` values inside the loader;
- environment table identity or type assumptions.

## Fix

SEAL3 no longer *fails integrity* on these **host-dependent heuristics**, nor
does it install/clear debug hooks. The loader now raises a distinct
`Lua transport primitives unavailable` message if essential decoder functions
are absent. It keeps data-related failure behavior unchanged:

- encoded alphabet and fragment syntax/length checks;
- runtime string decoding and per-fragment Adler checksum;
- aggregate checksum over all reconstructed bytes;
- distinct loader/environment errors where applicable;
- the inner VM's existing opcode, payload and handler integrity checks.

The change improves compatibility, not the cryptographic strength of SEAL3.
A hostile interpreter can still instrument Lua execution; no client-side Lua
obfuscator can guarantee the protected code is undumpable.

## Reproducible tests

`python v2/tests/v06_seal3_false_positive_regression.py --lua /path/to/lua54`

This builds two seeds in Sealed and Direct VM mode. With an isolated
**simulated Luau-style** host, it checks normal, existing-debug-hook,
nonstandard-getinfo, and clock-rewind cases. The previous Sealed builds fail
with `integrity check failed` in these cases; the fixed Sealed build produces
the original output. It additionally checks source output, compact executable
body, loader-unavailable behavior, and rejects a modified ciphertext byte.

Other tests run:

- `v2/tests/v06_false_positive_fix.lua`
- `v2/tests/v06_host_compat_smoke.py`
- `v2/tests/v06_seal3_security_regression.lua`
- `v2/tests/v06_security_regression.lua`
- `v2/tests/v06_browser_smoke.py`
- `v2/tests/v06_txt_upload_browser_smoke.py`

**Not tested on a live Roblox client.** A real-world error may have another
cause; the old traceback alone does not reveal which SEAL3 check fired.

## Distribution

The product remains **GsXFuscator V0.6**; CLI and web bundles both contain
this change. The anime ASCII, Protected By banner, and compact executable Lua
remain. `.lua`, `.luau`, `.txt` uploads and drag/drop remain. Redeploy the
Cloudflare Pages ZIP and **regenerate affected obfuscated files**: previously
compiled Lua files do not update when the web UI is updated.
