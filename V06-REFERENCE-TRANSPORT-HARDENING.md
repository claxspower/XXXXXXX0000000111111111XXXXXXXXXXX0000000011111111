# GsXFuscator V0.6 — Canonical Transport Hardening & Luau Reference Coverage

## Sources reviewed
Three files provided by the user: `ironbrew1_output.antitamper.luau`,
`ig67.zip` and `50dtc.zip`. None was run as an untrusted program.

- **IronBrew1 example:** Demonstrates exact low/high 16-bit 32-bit modular
  multiplication, rolling-state transforms and bounded byte readers. GsX's
  packed VM already includes a precise 32-bit multiplication helper, length
  checks, authenticated transport checks and lazy block validation. We did not
  replace working functions simply to match another implementation.
- **ig67 archive:** Includes VM, bytecode and control-flow implementations, but
  some `protect/*` emitters overwrite process-global `debug` and `string.dump`
  functions or insert infinite loops into protected programs. We deliberately
  **did not import** those destructive checks: they can freeze legitimate
  applications, break host debug tooling and worsen false positives. This is
  a defensive design decision, not an assertion that the project has no ideas.
- **50dtc archive:** Provides 50 Roblox/Luau behavior probes. The exact bytes
  are now archived under `v2/tests/roblox_luau_reference/`, with SHA-256
  manifest. These are **reference fixtures only**, never run automatically.
  They include API-error tests and executor-specific calls. Roblox behavior
  and real executor compatibility were **not** validated.

## New engine fix: canonical transport

`v2/src/vmgen.lua` emits the Base-91 transport decoder for packed VM9 bytecode.
Previous decoder silently skipped a group when its first glyph was invalid,
meaning that inserting a non-data group such as `====` into the encoded
payload could change the obfuscated source without changing the VM bytecode
or tripping the decoded-bytes checksum. This is a **noncanonical transport
malleability** bug, not disclosure of the original user program.

The decoder now rejects:

1. Non-multiple-of-four transport lengths.
2. Unknown alphabet glyphs and incomplete groups.
3. Padding anywhere except the final group, with exact `=`/`==` forms.
4. Numeric groups outside 1-byte, 2-byte and 3-byte canonical ranges.

The checks occur inside the existing decode pass; no extra full-payload scan
or extra decoded copy is added. Existing authenticated packed bytecode,
fragment integrity, VM9 dispatch banking, WindowGuard, auto Fast Load and
anti-debug checks are kept.

## Evidence and test results

- Side-by-side reproducibility test on the same packed VM input:
  the prior decoder executed after an invalid `====` group was inserted;
  the patched decoder rejected it with `bytecode: invalid transport`.
- `v06_transport_canonical_regression.lua`: **4/4 negative cases rejected**.
- `v06_dispatch_bank_regression.lua`: **6 variants passed**.
- `v06_piecewise_opcode_regression.lua`: **4 variants passed**, modified key rejected.
- `v06_adaptive_protosalt.lua`: passed.
- `v06_fastload_regression.lua`: **16 variants passed**.
- `vm9_pipeline_proof.lua`: two seeds Direct/Sealed, packed audits and
  negative integrity tests passed.
- 50 uploaded Roblox/Luau reference scripts: **50/50 parsed**, **50/50
  statically compiled** by the Lua front-end. These scripts were **not run**
  in Roblox/Luau and their runtime behavior is **not** established.
- Two Strong demonstration builds, Direct and Sealed, both returned
  `GSX_REFERENCE_HARDENED 455` using local PUC Lua 5.4.
- Web dashboard rebuilt, hosted worker passed Node syntax check, and
  Node/Wasmoon Sealed artifact compiled and executed with expected output
  `GSX_TEST_2026 55 18`. This is not a real browser UI test.
- Native packed VM benchmark, same seeded 1,000-line program:
  prior output 90,455 bytes, hardened output 91,246 bytes (+791 bytes);
  7 runs each: medians 121.7 ms vs 119.2 ms. Small samples and system noise
  preclude a broad speed claim.

## Retained project requirements

Visible signature `--[[ This, File Protected By GsXFuscator V0.6 ]]`, anime
ASCII, one-line executable Lua beneath the comment banner, automatic Fast Load
for Sealed output, no Fast Load UI toggle, 10 MiB input cap and `.lua`,
`.luau`, `.txt` uploads are retained. Cloudflare Pages packaging includes
only website assets; no reference fixtures are exposed by the web deployment.

## Threat-model limits

Noncanonical source mutation is now rejected but decoding, instrumentation,
output logging and VM-handler analysis remain possible when an adversary
controls the host interpreter. This update does **not** make the VM
undumpable, cryptographically secret, or demonstrably better than MoonSec or
Luraph. It does not guarantee compatibility with every live Roblox executor.

Run the local tests from project root with a Lua 5.4 runner:

```text
lua v2/tests/v06_transport_canonical_regression.lua
lua v2/tests/v06_roblox_reference_parser.lua
lua v2/tests/v06_roblox_reference_compile.lua
lua v2/tests/v06_dispatch_bank_regression.lua
lua v2/tests/vm9_pipeline_proof.lua
```
