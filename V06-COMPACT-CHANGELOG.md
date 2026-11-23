# GsXFuscator V0.6 — Compact transport update

- Version label **V0.6** retained.
- Sealed and Direct VM Lua outputs are token-minified and have no banner/newlines by default in both CLI and browser.
- SEAL3 fragment transform: per-fragment XOR keystream -> index-shift/feedback -> byte reversal, followed by randomized base64 alphabet. Each fragment has independent seed and runtime Adler-32 verification. These are **reversible obfuscation transforms, not cryptographic secrecy or authentication**.
- Decoder for the fragment transform is assembled as source and compiled via `loadstring` or `load` at runtime; a static analyst can still reconstruct it.
- Clock-dependent opaque predicate varies at runtime, but is algebraically invariant (no flaky timing thresholds).
- Existing runtime-computed per-fragment and aggregate checksums retained; expected values are encoded in artifact metadata and are not a secret.
- Best-effort debug.gethook and optional temporary debug.sethook sanity probe; pcall/xpcall behavior tests retained.
- Best-effort getfenv/_ENV/_G consistency test; Lua hosts that intentionally diverge from standard environment bindings may be incompatible.

Limitations: No embedded key can remain secret from an adversary controlling the Lua runtime. Anti-debug cannot block all hooking or dumps. No guaranteed 10/10 or tamper-proof protection. Verification should be repeated for each target Lua/Luau host.

## Verified in this update

- Native Lua 5.4: four Strong VM artifacts (sealed/direct, two seeds) matched reference output under strict verification.
- Browser Chromium: both sealed and direct builds were single line and each ran successfully under native Lua 5.4.
- Negative tests: ciphertext mutation, installed `debug.sethook` and an inconsistent `_G` environment were rejected.
- Existing verifier regression checks passed.

Lua 5.1–5.3 native matrices were **not** executed.
