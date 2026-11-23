## GsXFuscator V0.6 — Luau Anti-Environment hardening (2026-11-23)

Added four capability-gated Luau behavior checks (table.pack nil gap, table.freeze
write protection, buffer u16 roundtrip, debug.info function identity), with two or
more randomly selected per build. Protected periodic primitive snapshots now
include the optional table and buffer APIs too. Valid scripts stay silent;
verified tampering uses the existing bounded GsxFuscator incident response.
See [V06-ANTIENV-HARDENING.md](V06-ANTIENV-HARDENING.md) for test evidence and
explicit limitations (no real Roblox run or unbreakable confidentiality claim).

## GsXFuscator V0.6 — normal Execute false-positive warning fix (2026-11-23)

**Normal code now runs with zero GsxFuscator startup warnings.** Removed the
unconditional `earlyNotice()` that printed the incident message 16 times on
every Luau execution (including Potassium). The bounded 256-warning reaction
remains only on verified VM9/SEAL2/SEAL4 integrity failures. Both Direct VM
and Sealed delivery were tested; see [technical regression](V06-NORMAL-EXECUTE-NO-SPAM-FIX.md).

## ClaxGuard verified-integrity response (2026-11-23)

The VM9, SEAL2 and SEAL4 fail paths now produce up to 256 exactly specified
GsxFuscator warnings on verified integrity incidents (once per layer),
then halt. Clean output stays silent. The browser module list was updated.
See [CLAX-GUARD-REPORT.md](CLAX-GUARD-REPORT.md) for precise limitations and
regression results. **This is an incident signal, not dump-proof encryption.**

## Latest defensive hardening (V0.6 visible signature)

The VM9 opcode offset now includes a per-prototype, window-dependent term, while keeping the original four-word per-prototype mixer and integrity anchor. See [V06-OPCODE-WINDOW-HARDENING.md](V06-OPCODE-WINDOW-HARDENING.md) for the design, tests, overhead, and limitations. Fast Load remains automatic for Sealed output.

**V0.6 AdaptiveVM + ProtoShield:** Strong/Compact now distributes VM9 handler aliases by opcode frequency and adds a prototype-specific salt to the existing PC operand mask. See `V06-ADAPTIVE-VM-PROTOSHIELD.md` for test results and limitations.

## 2026-11-22 VM9 verified builds

The Strong + Sealed path stores real VM9 bytecode, not original Lua plaintext. Build-time packed-bytecode round-trip auditing is now mandatory. A synthetic two-seed regression validates opcode and handler diversification, and negative tests reject tampered payloads. See [VM9 verification report](VM9-VERIFICATION-REPORT.md). The visible output signature stays **GsXFuscator V0.6**.

# GsXFuscator — V0.6 imzalı State-Machine güncellemesi

Bu paket, V1.0.3 VM9/SEAL4 motoru temel alınarak oluşturulmuştur. Kullanıcıya
 görünen sürüm ve üretilen Lua imzası **V0.6** olarak ayarlanmıştır; geçmişte
 uygulanan güvenlik/düzeltme katmanları geriye alınmamıştır.

**Yeni:** SEAL4'ün beş gerçek iş aşaması (fragment al, base decode, cipher çöz,
Adler-32 doğrula, ekle) artık farklı seed'lerde değişen durum numaraları ve
karıştırılmış `if/elseif` dispatch sırasıyla yürütülür. Kaynak kodun AST control-flow
flattening (`v2/src/flatten.lua`) ve VM9 zaten mevcuttu. Bu değişiklik dış
paketleme/loader katmanına özeldir, sanal makine komut döngüsünü tekrar yazmaz.

- Hem web hem CLI: `.lua` / `.luau` / `.txt` desteği ve sıkışık çalıştırılabilir Lua.
- Görünür başlık: `--[[ This, File Protected By GsXFuscator V0.6 ]]`.
- Anime ASCII: yorum olarak korunmuştur; bütün dosya tek satır değildir.
- SEAL4 parça checksum'ları ve VM9 bütünlük korumaları değişmeden korunur.
- Sürüm etiketi güvenlik göstergesi değildir. State-machine, deobfuscation'ı imkânsız
  yapmaz; yorumlayıcıyı kontrol eden biri kodu gözleyebilir.

Testler ve ölçümler: [V06-STATE-MACHINE-REPORT.md](V06-STATE-MACHINE-REPORT.md).

---

> Motorun geçmiş sürüm notları: [V1.0.3 changes and verification](V1.0.3-CHANGELOG.md).

## VM9 / SEAL4 motorunun geçmişi (1.0.3 kaynak tabanı)

**Motorun kaynak tabanı:** 1.0.3. Dağıtımın görünen etiketi ve korumalı dosya imzası V0.6 olarak ayarlanmıştır.

The outer Sealed transport now uses one shuffled, sparse-index lookup pool for API members and encoded payload fragments, arithmetic-generated API names, a `kb` rawget fallback, and transient-reference cleanup. VM9, SEAL2 verification, the anime ASCII header, `.lua` / `.luau` / `.txt` drag-and-drop, compact executable output, and browser builds are preserved. The built-in debug hook probe still respects host profilers.

CLI: `lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify`.

Opt-in CLI `--coroutine-wrap` is **not** dump-proof and may change coroutine behavior. Do not enable for yielding scripts. Sealed mode requires `load` or `loadstring`; use `--no-seal` in restricted runtimes. Never depend on this obfuscator for cryptographic secrecy or trusted-client execution.

Read `V1-IMPLEMENTATION.md` and `V1-TEST-REPORT.md` for implementation and test limitations.

---

## Historical readme from V0.6

**Latest V0.6 safe hook fix:** see [V06-SAFE-HOOK-FIX.md](V06-SAFE-HOOK-FIX.md). The active debug hook self-test preserves normal profiler hooks and no longer causes false integrity alarms; payload and VM integrity checks remain enabled.

**Latest V0.6 SEAL3 compatibility fix:** see [V06-SEAL3-HOST-FALSE-POSITIVE-FIX.md](V06-SEAL3-HOST-FALSE-POSITIVE-FIX.md) for the specific `Line 43 - function _bad` false-positive repair and regression tests.

**V0.6 current hotfix:** [Roblox/Luau false-positive integrity fix](V06-INTEGRITY-FALSE-POSITIVE-FIX.md). Normal Roblox API differences no longer cause a hard stop; VM payload and opcode tamper detection remains fail-closed. Rebuild old protected scripts.

**Newest V0.6 maintenance:** [Dump-resilience and measured string-leak reduction](V06-DUMP-RESILIENCE.md).

**Latest V0.6 maintenance:** [Dynamic accumulator notes](V06-DYNAMIC-ACCUMULATOR.md).

# GsXFuscator V0.6 — Unified Lua and Anime ASCII Update

The current release **stays V0.6**. The browser has one **Obfuscate** button and no `Target runtime` dropdown. The file chooser and drag-and-drop zone accept `.lua`, `.luau` and `.txt` (UTF-8 Lua source, up to 10 MiB); Luau delivery is inferred from `.luau` or common Roblox-only syntax patterns, while ordinary Lua defaults to the sealed transport. The inference is heuristic, not a guarantee about the actual host.

### Lua output

Every generated output begins with:

```lua
--[[ This, File Protected By GsXFuscator V0.6 ]]
```

The original anime ASCII art follows as a single Lua long comment; it is the original `v2/assets/anime_ascìì.txt` artwork and adds about 10 KB **once per file**. **The executable obfuscated code is still a single token-minified line after the art.** The full file includes multiple lines of commentary because the user explicitly requested visible ASCII artwork.

### VM integrity and size

The two byte-for-byte matching opcode-keystream tables were intentional, not a parser bug: the second was the live-tamper anchor. V0.6 now emits one 32-bit checksum per prototype rather than a second four-value table. The VM checks each prototype against its independent checksum before and during dispatch. This reduces duplication; an attacker controlling Lua execution can still modify both data and validation logic. This is not cryptographic authentication.

Strong + compact VM, SEAL3/SEAL2 (for standard Lua), existing anti-debug, anti-tamper, self-modifying VM bytecode, runtime validation and seeded diversification remain. CLI `--no-seal` still provides Direct VM explicitly; web users no longer choose a target runtime.

**Limitations:** xxHash64, Adler32, and an unkeyed VM checksum are not encryption or a secret trust anchor. VM code can be extracted or traced by an attacker controlling the interpreter. Native Lua 5.1–5.3 and the actual Roblox/Luau host have not been exhaustively tested in this build. Large sources may still produce files larger than 10 MB; no size ceiling is guaranteed without trading off protections.

### Run locally

```bash
lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify
```

### Rebuild the browser app

```bash
python web/build12.py
```

Upload the **contents** of `public/` to Cloudflare Pages to deploy the UI. This package does not modify the live domain.

### Tests in this update

```bash
python v2/tests/v06_unified_anime_smoke.py
python v2/tests/v06_unified_browser_smoke.py
```

Both modes were tested with a small Lua program under a native Lua 5.4 runner; Chromium/Wasmoon generated both outputs. A modified opcode-keystream coefficient and active debug hook were rejected. See [V06-UNIFIED-UPDATE.md](V06-UNIFIED-UPDATE.md) for details, and [README-HISTORICAL.md](README-HISTORICAL.md) for older development notes that may refer to prior branding rules.

### `.txt` files in the web dashboard

Drag a UTF-8 text file containing Lua source onto the Obfuscator upload zone, or choose it using the file picker. It follows the same parser, protection profile, and one-line `.lua` output as `.lua` files; `.txt` does **not** enable arbitrary plaintext obfuscation. The source upload limit is 10 MiB (10,485,760 UTF-8 bytes). The browser compiler has no application-level build deadline. Unsupported types, oversized files, invalid UTF-8 and empty input are rejected. See `v2/tests/v06_txt_upload_browser_smoke.py` for UI tests.

## V0.6 Fast Load and fragment-order integrity

The SEAL4 decoder now uses a grouped Base64 recovery path and computes fragment Adler-32 in the same decode pass (**Fast Load**, on by default). The web UI no longer shows a Fast Load toggle: Sealed artifacts always use it. The CLI still accepts `--fast-load` as an optional compatibility alias, but rejects `--no-fast-load`. It does not disable integrity checks, and it applies only to Sealed delivery; Direct VM already skips that wrapper. Shuffled fragment-order metadata is validated once at startup. See [`V06-FAST-LOAD-DEX-HARDENING.md`](V06-FAST-LOAD-DEX-HARDENING.md) for measurements, limitations, and a static analysis of `dump(2).zip`.

## V0.6 PC-dependent VM operand protection

Live VM9 opcode aliases now apply an additional **program-counter-dependent reversible mask** to register-index operands, in addition to their existing randomized layouts and static masks. The fourth (floating-point capable) immediate remains unchanged for exact Lua subtype behavior. This adds a small VM dispatch cost and is not cryptographic secrecy. See [`V06-AUTO-FAST-PC-MASK.md`](V06-AUTO-FAST-PC-MASK.md).


## Dispatch-Bank validation update (visible V0.6)

The VM9 generator now uses a reversible per-prototype/per-PC-window dispatch bank. For correctness and portability, see `V06-DISPATCH-BANK-VALIDATION.md`. The full-source archive includes 384 Lua regression programs and 384 expected outputs. This does not imply cryptographic protection from a machine running the code.

## Canonical transport hardening / Roblox reference corpus

The packed VM9 decoder now rejects noncanonical Base-91 transport instead of
silently skipping invalid groups. See `V06-REFERENCE-TRANSPORT-HARDENING.md`.
The 50 user-provided Roblox/Luau examples in
`v2/tests/roblox_luau_reference/` are **static compatibility fixtures**,
not programs to execute in a live game or automatic build pipeline.

## Dead String Injection (2026-11-23)

Every delivered Direct VM or Sealed artifact now includes exactly **2,879** distinct,
unused Lua string literals, inserted in unreachable branches after the V0.6
branding. This applies to CLI, programmatic `src.artifact.build` and the web
compiler (including multi-part builds). They are separate from the existing
encrypted string pool and its integrity canaries. No strings are allocated
by these branches at runtime; Lua still must parse the extra source, and
removing dead strings does not expose or alter the protected VM. This is
obfuscation noise, **not** a cryptographic security guarantee.

## Encoded dead data and prototype-mask fix (2026-11-23)

After the existing 2,879 distinct plain dead strings, each Direct and Sealed
output includes **1,936 additional inert encoded literals**: **646 standard
Base64**, **645 RFC 4648 Base32**, and **645 RFC 1924 Base85**. Encoding is
valid and seed-dependent; no decoded payload is executed. Added encoded literals
are grouped into 16 unreachable branches; they have no effect on program
behavior but increase output and parse time. They should **not** be treated as
a meaningful defense against a deobfuscator that eliminates dead code.

PC-dependent operand masks now select one of 24 small prime moduli per
handler, with nonzero prototype multipliers strictly below that modulus. This
prevents the prototype term from disappearing modulo 127 (identified in the
VS comparison) and eliminates one fixed per-handler normalization constant.
The updated encoder/decoder remains symmetric and is regression-tested.
