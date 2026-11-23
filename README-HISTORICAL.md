# GsXFuscator V0.6 — Runtime Integrity Refinement (22 Kasım 2026)

**Version remains V0.6.** All generated Lua output remains token-minified into one line by default.

This maintenance revision replaces the provably trivial `n(n+1) %% 2` branch with an execution-time checksum challenge tied to the bytes actually decoded. `_clockSlot` now parameterizes a runtime-compiled nibble XOR lookup and both decoder table construction and lookups; removing just the slot computation therefore breaks the decoder. Hosts without `os.clock`, normal `_G`, or `print` fail closed rather than defaulting to seed 0. Standard Lua debug-library presence is **not** automatically considered malicious; a limited sanity check and active-hook checks are retained. This creates runtime variability, not cryptographic secrecy or universal sandbox detection.

The existing multi-fragment XOR/index-shift/reversal, per-fragment Adler32, VM9 bytecode and CLI/browser compilation are preserved.

- Primary source: `v2/src/seal.lua` (SEAL3 loader and dynamically compiled decoder).
- VM: `v2/src/vmgen.lua`, `v2/src/bytecode.lua`.
- Detailed verification: `V06-RUNTIME-REFINEMENT.md`.
- CLI: `lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify`.
- Web: `python web/build12.py`; deploy `public/` to Cloudflare Pages.

**Security limits:** client-side reversible encoding is not strong encryption; local interpreter control can inspect loader, VM and decoded payload. Checksum fields travel in the artifact and are not a signature. Rejecting deliberately restricted hosts is a compatibility tradeoff. Native Lua 5.1–5.3 and nonstandard hosts still require validation.

---

# GsXFuscator V0.6 — Compact + Runtime Hardening (22 Kasım 2026)

**V0.6 stays V0.6.** All produced Lua artifacts are token-minified with zero newline characters; this applies to CLI (sealed/direct) and browser builds (sealed/direct/streamed). The optional visual banner is intentionally omitted from generated artifacts.

**SEAL3 improvements:** independently seeded fragments now apply an XOR keystream, positional index shift/feedback, byte reversal, and randomized 64-character transport encoding. The inverse fragment decoder is assembled and compiled at runtime using `loadstring` (Lua 5.1) or `load` (Lua 5.2+). Per-fragment and overall checksums are calculated during execution and compared with encoded metadata. A clock-varying but invariant opaque predicate, best-effort hook probe, `pcall`/`xpcall` checks, and coherent `_G` / `getfenv` / `_ENV` checks are present. Existing VM9 remains intact.

**Limits:** These are reversible obfuscation layers, **not cryptographic secrecy**. Tamper checks are not digital signatures; client-controlled Lua environments can intercept or patch execution. The optional hook and environment probes may be unavailable or incompatible with some hosts; fully verified on native Lua 5.4 and Chromium/Wasmoon only.

- Detailed changes: [V06-COMPACT-CHANGELOG.md](V06-COMPACT-CHANGELOG.md)
- CLI example: `lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify`
- Rebuild web: `python web/build12.py`; deploy the **contents** of `public/` to Cloudflare Pages.

---

# GsXFuscator V0.6 — SEAL3 / VM9 Geliştirilmiş Yapı (22 Kasım 2026)

The **V0.6 default sealed artifact** uses independently seeded, randomized SEAL3 fragments over the existing SEAL2 and VM9 engine. The visible wrapper no longer exposes the old `QT`, `G`, key concatenation, `EXPECTED` constants, Discord/ASCII brand art or an unfragmented alphabet. VM bytecode, flattening, opaque predicates, self-modifying bytecode, anti-debug, runtime integrity checks and per-build diversification are included.

**Important:** The Lua host can still inspect, decompile or intercept execution. No output is guaranteed un-dumpable, tamper-proof or 10/10 secure. Native Lua 5.4 and a Chromium/Wasmoon build were tested; Lua 5.1–5.3 have not been fully retested.

- [V0.6 detailed checklist and tests](v2/docs/V06-SEAL3-RELEASE-NOTES.md)
- `lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify`
- `lua v2/obfuscator.lua input.lua output.lua --watermark demo --fragment-size 512`
- `python web/build12.py` (then deploy `public/`)

---

## Önceki V0.6 uygulamasının notları (geriye dönük uyumluluk için tutuldu)

# GsXFuscator V0.6 — Graphite Edition

> **Marka güncellemesi (22 Kasım 2026):** Claxfuscator adı GsXFuscator olarak değişti. Discord adresi **https://discord.gg/cHawU8Wmzj** korunur. Site simgesi ve logo kullanıcı tarafından verilen krom GSX görselidir. Direct/Sealed Lua dosyalarının başı `--[[ This, File Protected By GsXFuscator V0.6 ... ]]` satırıyla açılır; hemen arkasında kullanıcıdan alınan Unicode ASCII çalışma, Lua satır yorumları içinde gelir. Harici `SEAL2`/`DIRECT` etiketi basılmaz. Kaynak kodu tekrar derlemek gerekir; eski obfuscate çıktılar değişmez.

**Not:** Çok satırlı Unicode açıklama nedeniyle yeni çıktılar tek satır ve yalnız ASCII metin değildir. Korunan yürütme kodu değişmeden çalışır. Koruma kontrolleri kriptografik imza oluşturmaz. Tema Graphite Light/Night ve otomatik güçlü profil sabit kalır. Önceki depolama anahtarları (`clax.workspace.*`) kasıtlı olarak korunarak kullanıcı tercihleri taşınır. Ayrıntılar: [Marka ve çıktı başlığı](v2/docs/GSXFUSCATOR-BRANDING.md).


Tek dosyalı Lua obfuscator, V0.6 sürüm kimliğini kullanan güçlü VM motoru ve çevrimdışı kullanılabilen web dashboard'u. **V0.6, V0.5 Graphite arayüzünü ve VM9/SEAL2 mimarisini korur; tarayıcıda CSPRNG ile derleme çeşitliliği ve daha doğru, kısıtlı doğrulama ekler. Korumanın 10/10 olduğu iddia edilmez.**

**[V0.6 sürüm notları ve gerçek testler](v2/docs/V06-RELEASE-NOTES.md)**

## Görünüm

- **Tek renk ailesi: Graphite.** Çoklu tema/renk seçme sistemi silindi.
- **İki ışık modu: Light ve Night.** Başlangıç Night; seçim güvenli biçimde `localStorage`'da saklanır. Eski tema tercihi okunmaz ve ilk kayıtla temizlenir.
- **Elegant başlıklar:** Cormorant Garamond kullanılabiliyorsa; çevrimdışı Georgia yedeği. Uzun metin, menü, buton, hata ve dokümantasyon için yüksek okunabilirlikli işletim sistemi sans-serif yazı tipleri kullanılır; ayrı font seçme menüsü yoktur.
- **Büyük okuma metni:** Settings → Appearance bölümünde kalıcı büyütme. Tarayıcı yakınlaştırması ve işletim sistemi metin ölçeğine uyum.
- **Hafif, yumuşak etkileşimler:** Light/Night kaydırma, hızlı buton basma tepkisi ve kısa opaklık/geçiş animasyonları. `prefers-reduced-motion`, `prefers-reduced-data` ve tarayıcı düşük bellek/savedata sinyallerinde dekoratif efektler azaltılır. `navigator.deviceMemory` bulunmuyorsa RAM tahmini yapılmaz.
- History ve File to Link Converter kaldırılmış durumda kalır. Rules & Guidelines **8 kural** olarak korunur. Sürüm etiketi ve çıktı başlığı **V0.6** oldu; Seal/Direct iç imzaları eklenmez.

## Hızlı başlangıç

```sh
python web/build12.py
# index.html veya public/index.html dosyasını aç
lua v2/obfuscator.lua input.lua output.lua --preset strong --strict-verify
```

Web derlemesi Strong + Standard VM + Anti-Tamper + Anti-Debug + Sealed yapılandırmasını otomatik seçer; Compact VM açılmaz. CLI'de `--no-seal` seçeneği dış yükleme çağrısından kaçınmak için kullanılabilir. Seal daha fazla statik gizleme sağlar ama çalışma anında `load` ile izlenebilir.

## Runtime / Bytecode düzeltmesi (V0.5)

- Sealed LZSS çözücü bitleri tek tek okumak yerine sınırları kontrol edilmiş 24 bitlik pencereden çözer; 36 sınır durumu test edildi.
- FNV-1a ve Adler-32 blok kontrolü tek byte geçişine taşındı; checksum biçimi ve bütünlük davranışı değişmedi.
- Tek örnekte Strong Sealed Auto medyan cold-start **0,5734 → 0,4310 saniye**; bu tüm iş yükleri için bir garanti değildir. Güçlü VM'nin çalışma zamanı maliyeti devam eder.
- Bytecode/handler tamper testleri ve dinamik loader gözlemi yeniden doğrulandı. Dış seal katmanının statik olarak çözülebilirliği ve host'un runtime analiz imkânı hâlâ geçerlidir.
- Tek komutla gerçek test: `python v2/tests/benchmark_matrix.py --lua lua5.4 --runs 5 --json result.json`.


## Complete developer documentation / Tam geliştirici rehberi

**[FULL DOCUMENTATION HUB — API, from-scratch compiler and VM tutorials](v2/docs/FULL-DOCUMENTATION.md)**

This learning track includes a working independent toy VM obfuscator, source-parser inspection tools, the actual register VM ISA/bytecode layout, extension rules, HTTP deployment, security boundaries and reproducible tests. Türkçe rehber: [TR-START](v2/docs/TR-START.md).

## Belgeler

| Belge | İçerik |
|---|---|
| [Görünüm ve erişilebilirlik](v2/docs/GRAPHITE-ACCESSIBILITY.md) | Graphite renkler, modların kaydedilmesi, düşük RAM stratejisi, erişilebilirlik testleri |
| [Runtime bakım raporu](v2/docs/V05-RUNTIME-HARDENING.md) | Dış katman, VM, anti-debug ve benchmark: ölçülmüş sonuçlar, kalan sınırlar |
| [Runtime doğrulaması](v2/docs/VERIFICATION-RUNTIME.md) | 12 Lua modülü, bozulma testleri, performans ve sınırlamalar |
| [Performans ve tehdit modeli](v2/docs/RUNTIME-SECURITY-AND-BENCHMARKS.md) | Statik çözme, VM analizi, anti-debug sınırları, tekrarlanabilir benchmark |
| [Doğrulama raporu](v2/docs/VERIFICATION-GRAPHITE.md) | Bu revizyonda çalıştırılan testlerin gerçek sonuçları |
| [API dokümantasyonu](v2/docs/API.md) | CLI, Lua modülleri ve HTTP build servisi için tam referans |
| [CLI](v2/docs/CLI.md) | Geliştirici komutları ve seçenekler |
| [Güvenlik](v2/SECURITY.md) | Koruma katmanları ve sınırları |
| [Dağıtım](web/DEPLOY.md) | Statik web veya yerel servis |

## Güvenlik ve uyumluluk sınırı

FNV ve Adler checksum'ları bozulmayı saptar; kriptografik kimlik doğrulama değildir. Çıktı dosyası/VM, çalıştıran host'un belleğinde analiz edilebilir. Lua 5.1–5.4 ve Luau uyumluluğunda gerçek platform üzerinde test gereklidir. Düşük RAM'li cihazlarda okunabilirlik iyileştirildi; büyük VM derlemelerinin mutlaka 1–3 GB RAM'de çalışacağı garantisi verilemez.

## V0.5 aktif anti-tamper revizyonu

Bu bakım revizyonunda VM handler referanslarının **tamamı** üçüncü bir bağımsız tabloda sabitlenir; her çalıştırılan handler ayrıca bu sabit kayıtla anında karşılaştırılır. Bu, canlı handler + yedek handler birlikte değiştirildiğinde eski altı örnekli korumanın gözden kaçırabildiği müdahaleleri saptamak içindir. Eski modüller, Graphite Light/Night, V0.5 imzası ve web'in güçlü otomatik profili korunur. Ayrıntılar: [Aktif müdahale testleri](v2/docs/V05-ACTIVE-TAMPER-TESTS.md). İstemci host'unun bütün Lua durumuna erişim sağlayabildiği bir senaryoda **kriptografik saldırı dayanıklılığı iddia edilmez**.

Test sonuçları ve ölçümler: [V0.5 güvenlik doğrulaması](v2/docs/VERIFICATION-SECURITY.md).

## V0.5 — Kontrollü saldırı testleri ve zorunlu ilk bütünlük denetimi

2026-11-22 revizyonu, kısa programların ilk periyodik kontrolü atlaması sorununu giderir: VM ilk komutu çalıştırmadan önce canary ve tam handler çapraz denetimi yapılır. Gerçek `debug.sethook` ve eşzamanlı handler müdahaleleriyle test edildi. **12/12 Lua 5.4 modülü geçti**; ayrıca dış Sealed VM'nin `load` izlemeyle elde edilebildiği doğrulandı. Bu sürüm **V0.5** olarak kalır; Graphite Light/Night ve kilitli güçlü profil değişmemiştir.

- [Kontrollü saldırı raporu](v2/docs/V05-ADVERSARIAL-VERIFICATION.md)
- [Test sonuçları tablosu](v2/docs/VERIFICATION-V05-REDTEAM.md)
- [Benchmark JSON](v2/docs/V05-ACTIVE-BENCHMARK.json)

**Sınır:** Kaynağın veya VM'nin profesyonel devirtualizer ile geri çıkarılmasının imkânsızlığı kanıtlanmadı; sealed `load` sınırı ve host kontrolündeki bellek analizi devam ediyor.

## V0.5 — Prototip boyutu ve metatable tespit düzeltmesi

Son rapordaki **249 sıfır uzunluklu prototip** problemi düzeltildi: selfmod için `P.total` / runtime `Q.t`, yoğun prototipler için `#P.c` doğrulanıyor. İlk kontrol tüm prototiplere, sonraki kontroller döngüsel olarak uygulanıyor. `__newindex` artık eklemeyi sessizce yutmuyor; `rawset` ile eklenen fazladan handler/prototip anahtarları tablonun tam sayımıyla yakalanıyor. Luau `table.freeze` varsa kök tablolar gerçekten donduruluyor; standart Lua'da metatable tek başına değiştirilemezlik oluşturmaz.

[Bulgular, teknik tasarım ve tekrarlanabilir testler](v2/docs/V05-PROTOTYPE-INTEGRITY-FIX.md) · [Yeni test ve benchmark raporu](v2/docs/VERIFICATION-PROTOTYPE.md). **Sürüm V0.5, Graphite Light/Night ve otomatik güçlü profil korunur.**

## GsXFuscator V0.6 — runtime CFI ve Discord kartı revizyonu

Görselin altındaki ekstra `PROTECTED BY GsX FUSCATOR` etiketi kaldırıldı; çok satırlı ASCII satır başına Lua yorumuyla korunur. Discord Community butonundaki açıklama kaldırıldı, görsel ve bağlantı kaldı. VM, program sayacının sınır/tam sayı doğrulaması, komut tipi ve dal hedefi denetimi, opcode mixer çapraz referansı ile canlı hook gözlemi ekledi. Testler ve sınırlar: [V0.5 VM runtime CFI](v2/docs/GSX-V05-VM-RUNTIME-CFI.md).

## V0.5 — Browser compiler startup reliability

The dashboard now ships a dedicated same-origin `public/compiler-worker.js`
with a bundled offline fallback. Build with `python web/build12.py` and deploy
**all files in `public/`**. Worker initialization and compile-time errors are
reported separately, without weakening the fixed Strong/Standard/Sealed
protection profile. See [Web deployment](web/DEPLOY.md) and
[Worker verification](v2/docs/GSX-V05-BROWSER-WORKER-VERIFICATION.md).

## V0.6 Compact Output (default)

The obfuscator now defaults to Strong/compact VM9 in CLI and browser. Both sealed and direct outputs are minified on one line and begin with `--[[ This, File Protected By GsXFuscator V0.6 ]]`. Decorative ASCII-art output was intentionally removed to minimize generated Lua size. Use `--vm-size standard` explicitly for extra redundant VM handlers (larger files). Full details in `V06-SIZE-OPTIMIZATION.md`.
