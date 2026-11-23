# GsXFuscator V0.6 — Luau/host compatibility correction

- Removed the false assumption that `_G == getfenv(1)` and `_G.print` must exist. In Roblox/Luau the shared `_G` table can legitimately be empty and distinct from the per-script global environment.
- Kept the existing SEAL3 per-fragment integrity checks, decoded-payload checksum, execution-time decoder, and VM protections. This does not disable the actual payload corruption checks.
- The `pcall`/`xpcall` sanity probe now tolerates host-added error prefixes while requiring the unique test token.
- Debug inspection first checks the script's actual environment, not only raw entries in the shared `_G` table.
- When `load`/`loadstring` is unavailable, Sealed mode now reports a meaningful mode limitation instead of mislabeling it as tampering. **Sealed mode still requires dynamic loading.** Direct VM (`--no-seal`) does not use the outer `loadstring`/`load` decoder.
- This does not prove Roblox/Luau native compatibility; the actual host still needs dedicated testing, and the VM itself has separate guards.
- Version is unchanged: **V0.6**. Output stays minified to one line and begins with `--[[ This, File Protected By GsXFuscator V0.6 ]]`.

## CLI

```sh
lua v2/obfuscator.lua input.lua output.lua --preset strong --no-seal --strict-verify
```

Use Direct VM for host environments without dynamic Lua source loading. Verification in native Lua does not by itself prove execution on Roblox/Luau.
