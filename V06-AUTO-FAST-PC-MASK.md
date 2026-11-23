# GsXFuscator V0.6 — automatic Fast Load and position-varying VM operand mask

- Web Fast Load toggle removed from HTML; browser worker and Lua driver always use the fast SEAL4 loader.
- CLI `--no-fast-load` is no longer supported. `--fast-load` remains an accepted compatibility alias.
- The reference decoder remains in `src.seal` for internal regression comparisons only.
- VM9 real handler aliases now decode a second reversible PC-dependent mask for the first three register operand fields. The fourth field (immediate float) is unchanged.
- No claim of authenticated secrecy or a guaranteed 9.7/10 score. The generated VM still runs under an observable host and can be studied.
- Target: same semantics, improved resistance to static operand templates. Measure its runtime cost in representative scripts.
