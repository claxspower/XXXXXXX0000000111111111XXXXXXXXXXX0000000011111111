# GsXFuscator V0.6 — Safe active hook self-test and false-positive repair

The version stays **V0.6**. This maintenance release corrects a real
false-positive: a legitimate profiler hook could make the generated VM stop
with `GsXFuscator: integrity check failed`.

## Changed

- The one-shot active `debug.sethook` test now runs only if `debug.gethook`
  confirms there is **no existing hook on the current thread**.
- It registers a temporary count hook, verifies that the host actually
  reported the installed callback, exercises 16 loop iterations, and clears
  the temporary hook. A callback firing is the expected outcome.
- Unsupported, denied or unusual hook APIs are **inconclusive** rather than
  an automatic integrity failure. The self-test is only a weak corroborator.
- A pre-existing or newly attached debugger/profiler hook is no longer
  treated as payload tampering. Early hard-fail and late hook-presence latches
  were removed. VM bytecode, handler, and SEAL3 payload integrity checks remain.
- Runtime still runs the startup checks once. The guarded hook test is
  performed at startup only, not on every VM dispatch.
- Existing anime ASCII, short V0.6 banner, compact executable Lua,
  .lua/.luau/.txt drag-and-drop and single web flow remain unchanged.

## Tests performed (Lua 5.4)

- `v2/tests/v06_safe_hook_smoke.py`: Sealed and Direct modes across five
  host scenarios each (tracked temporary hook, pre-existing profiler hook,
  missing debug library, denied sethook, throwing gethook); **10/10 passed**.
- `v2/tests/v06_seal3_false_positive_regression.py`: 2 seeds, both modes,
  four environment cases, behavior equivalence and altered seal rejection.
- `v2/tests/v06_compact_hardening_smoke.py`: clean output, corrupt payload,
  pre-existing profiler hook, separate `_G`.
- `v2/tests/v05_active_attack_lab.lua`: short-run canary/handler tamper
  still rejected; pre-existing hook preserved.
- `v2/tests/v06_security_regression.lua`: verification sandbox protections.
- `v2/tests/v06_unified_browser_smoke.py`: Chromium web compilation in both
  Sealed and Direct VM modes.

## Security boundary and known limitations

This is Lua obfuscation/hardening, **not** an anti-analysis or cryptographic
trust boundary. A host that controls Lua can observe runtime strings and
intercept loaders or VM state. Ordinary profilers should not be equated with
an attacker. A real Roblox/Luau client was **not** available for testing;
Lua 5.1–5.3 were not exhaustively exercised. Existing obfuscated files must
be regenerated using this release.
