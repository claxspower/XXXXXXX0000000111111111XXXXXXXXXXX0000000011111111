# GsXFuscator V0.6 — State-machine iyileştirme raporu

## Değişiklikler

- **Kaynak:** `v2/src/seal.lua` — yeni `fragmentMachine(rng)` üreticisi.
- **Kapsam:** SEAL4 dış loader'ındaki beş gerçek iş adımı: veri satırı doğrulaması,
  Base64 taşıyıcı çözümü, per-fragment cipher çözümü, Adler-32 + global checksum,
  birleştirme/sonraki fragment. Her aşamanın state etiketi ve branch sırası
  derleme seed'ine göre değişir; bilinmeyen state veya aşım hatayla durur.
- **Mevcut:** AST state-machine (`src.flatten`) + VM9 zaten vardı; rapordaki
  "GsX'te hiç state-machine yok" iddiası bu yüzden tam doğru değildir.
- **Görünür imza:** `This, File Protected By GsXFuscator V0.6`; web ve
  CLI etiketleri V0.6. VM9 + SEAL4 + SEAL2 işlevleri korunur.
- **Uyumluluk:** `.lua`, `.luau`, `.txt` yükleme ve drag-and-drop korunur;
  anime ASCII yorumu korunur; yürütülen Lua kısmı sıkışık tek satırdır.

## Tekrarlanabilir testler

```bash
GSX_LUA=/path/to/lua5.4 python3 v2/tests/v06_state_machine_smoke.py
python3 web/build.py
```

### Bu çalışmada alınan sonuçlar

| Test | Sonuç |
|---|---|
| Lua 5.4 Strong Sealed + Direct, 2 seed ve strict verify | 4/4 geçti |
| SEAL4 fragment verisi bozma (2 seed) | 2/2 reddedildi |
| Aktif profiler hook'unun korunması | Geçti |
| Chromium `.txt` yükleme ve web derleme | Geçti |
| Browser derlemesindeki V0.6 imzası | Doğrulandı |

**1.000 satırlık aynı test kaynağı**, aynı seed (1789), aynı yerel Lua 5.4
çalıştırıcısı. Her çalıştırma süresi için üç ölçüm (duvar saati):

| Ölçüm | Baz sürüm | Yeni state machine |
|---|---:|---:|
| Çıktı boyutu | 379.530 B | 379.967 B |
| Derleme + strict verification | 2.922 ms | 2.937 ms |
| Çalıştırma medyanı | 987 ms | 972 ms |

Bu örneklemde ciddi bir ek maliyet yok; küçük performans farkları gürültü
olabilir. Lua 5.1, gerçek Roblox/FiveM ortamları bu testte çalıştırılmadı.

## Sınırlar

Bu yapı yalnızca *obfuscation/analiz maliyeti* artırır. Hakiki kriptografik
koruma sağlamaz ve çalıştırmayı kontrol eden üçüncü tarafların dump veya
izleme araçlarını kesin olarak engellemez. 77fuscator, Clair veya Luraph ile
bağımsız tersine mühendislik karşılaştırması yapılmadı; mutlak skor verilmedi.
