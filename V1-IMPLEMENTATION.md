# GsXFuscator V1.0 / V1.0.1 — Implementation notes

- [CLAIR-GAP] Single shuffled Lua `__pool` with encoded SEAL4 fragments and API tables/keys. `__order` contains only the fragment indices in decode order.
- [CLAIR-GAP] Per-byte arithmetic expressions are used for API-member name literals. They add static-analysis friction, not cryptographic protection.
- [CLAIR-GAP] `kb` rawget fallback retains false values and supports table metamethod lookups.
- [CLAIR-GAP] Runtime decoder is still assembled using loadstring/load; fragment lengths and Adler-32 are checked before loading VM9.
- [CLAIR-GAP] Transient pool/decoder data are set to nil before executing the loaded chunk. This cannot clear memory snapshots or defeat a host debugger.
- [CLAIR-GAP] Existing safe sethook probe is retained. We did not impose an unreliable `fired > 3` limit.
- [CLAIR-GAP] Unbranded error: `runtime verification failed`; no fabricated syntax/stack errors.
- [CLAIR-GAP] `--coroutine-wrap` opt-in for CLI Sealed mode only; disabled by default to avoid breaking yielding scripts. This is **not** dump protection.
- [CLAIR-GAP] VM9 already exists inside the Sealed payload; no extra mini-VM added.
- Roblox/Luau/FiveM environments are not claimed fully compatible without native runtime tests. Sealed mode requires loadstring/load; use Direct VM if unavailable.
- The keys and source required to run client-side code are available to the host. Neither obfuscation nor error masking guarantees confidentiality.
