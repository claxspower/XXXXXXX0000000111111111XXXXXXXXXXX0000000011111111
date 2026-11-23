# GsXFuscator V0.6 — Uyarı marka düzeltmesi

Önceki uyarı metnindeki yanlış marka adı, tam olarak `GsxFuscator` ile değiştirildi.

```lua
warn("GsxFuscator İs The Best Fuck Your Deobfuscator Or Dumper Bot :) Bye Have A Bad Day.")
```

- Kaynak modül: `v2/src/clax_alert.lua` (eski dosya/require adı geriye dönük uyumluluk için korundu).
- Web derleyicisi `web/build12.py` ile yeniden oluşturuldu. Base64 gömülü modül yeni metni içeriyor.
- `texlua v2/tests/v06_clax_incident_regression.lua` testleri VM, Base-91, SEAL4 ve SEAL2 için geçti. Dört negatif testte 100 uyarı; pozitif testlerde sıfır uyarı.
- Testte aynı olay iki kez tetiklenince ikinci kez 100 uyarı üretilmedi.
- Tek değişiklik uyarı marka metnidir; koruma mekanizmaları ve V0.6 imzası değiştirilmedi.

Not: Lua 5.1/Luau gibi ortamlarda `warn` varsa `warn`, yoksa `print` kullanılır.
