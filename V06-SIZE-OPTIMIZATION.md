# GsXFuscator V0.6 — Size optimization

Version remains V0.6. The delivered Lua output remains on a single line.

- Browser Worker now honors the requested VM size and delivery mode rather than overriding compact builds with `standard`.
- Strong **compact VM is now default** in CLI, Lua API and browser. The real VM9 bytecode, self-modifying bytecode, anti-debug and integrity controls are retained; redundant handler encodings are capped at 2 and decoy handlers at 24 in compact mode.
- For browser split builds, the strong chunk target is doubled to 256 KiB, reducing repeated VM runtimes where splitting is required.
- SEAL3 fragment target increased to 8192 bytes (previously 960) to eliminate per-fragment metadata and local-variable overhead.
- Compact single-line signature restored in sealed and direct output: `--[[ This, File Protected By GsXFuscator V0.6 ]]`. No decorative ASCII art or Discord banner in generated source.
- `--vm-size standard` explicitly enables the old, larger VM redundancy budget.
- All retained protections are best-effort deterrents, not an unbreakable cryptographic boundary. Reducing decoys and aliases reduces diversity; benchmark against original before use.
- Important: output size increases with input complexity; no honest guarantee of a specific maximum size for arbitrary source.
