# GsXFuscator V0.6 — Mixed Dead Data (10,000 cap)

- 2,879 existing inert strings; 7,121 encoded inert strings split into 2,374 Base64, 2,374 Base32, 2,373 RFC 1924 Base85.
- Seed-shuffled interleaving throughout the dead-data carrier, rather than separate blocks by encoding family. The entire carrier is still inserted after the visible header; it is **not woven into VM handler implementations**.
- Each group is bounded by a deterministic, nontrivial-but-false numeric predicate. A sufficiently capable deobfuscator can still recognize/remove this inert code.
- **Fixed 2026-11-23:** normal startup emits **zero GsxFuscator warnings**. Removed the unconditional 16-warning prelude, which appeared on ordinary Potassium `Execute`. Only verified VM9/SEAL2/SEAL4 incidents emit up to 256 warnings before stopping.
- This cannot force any external Discord bot to display text in its embed or prevent its attachment generation.
- The encoded decoys are randomized data in valid encodings, **not encrypted user source**; base encodings are reversible.
- Preserves branded header, anime art, single-line executable source, 10 MiB upload, Fast Load, VM9/SEAL4.

Verification details: see the top-level GsXFuscator_V0.6_Mixed10K_EarlyWarn256_Report.md downloadable report.
