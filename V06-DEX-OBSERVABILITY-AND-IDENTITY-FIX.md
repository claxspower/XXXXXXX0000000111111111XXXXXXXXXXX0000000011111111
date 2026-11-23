# GsXFuscator V0.6 — Dex dump analizi ve VM9 snapshot sertleştirmesi

**Tarih:** 22 Kasım 2026  
**Görünen imza:** `--[[ This, File Protected By GsXFuscator V0.6 ]]`  
**Kapsam:** Yerel Lua 5.4, Strong+Sealed/Direct VM, gönderilen Dex kayıtlarının statik analizi. Gerçek Roblox/Luau/FiveM çalıştırılmadı.

## Dump bulguları

1. İlk, kısa Dex kaydı API davranışları (`debug.traceback`, `setmetatable`, servisler), uzaktan UI kütüphanesi yüklemesi ve `CreatePanel` çağrı hatası içeriyor. Kayıt sonrasında yürütme izleri sürüyor. `-- Anti Tamper Detected Here` ifadesi dumper'ın yorumu; anti-tamper'ın gerçekten abort ettiğinin kanıtı değil. `Game.ClassName = ...` gibi satırlar da ham script yerine yeniden oluşturulmuş bir yürütme raporuyla karşı karşıya olduğumuzu düşündürüyor.
2. İkinci Dex raporunda 4.524 satır, 1.842 `debug.getupvalue==debug.getupvalue`, 1.842 `debug.getregistry==debug.getregistry` eşitlik kontrolü ve 191 `Parent` erişimi var. Çalışma `<25ms: infinitelooperror>` ile sona ermiş. Bu, orijinal Lua kaynak kodunun başarıyla devirtualize edildiğini göstermiyor. Dump gerçek API ve runtime davranışlarına ilişkin meta veri sızdırıyor.
3. Dışarıdan `game:HttpGet(...)` + `loadstring(response)()` ile indirilen Lua, koruma dışındaki gerçek bir tedarik zinciri riskidir. Koruyucu runtime kodu tarafından otomatik olarak üretilmiş olduğunu gösteren kanıt bulunmuyor. Uzaktan bağımlılığı sabit commit/sürüm ve hash ile doğrulamak daha sağlıklı.

## Gerçek kod değişikliği

Dosya: `v2/src/vmgen.lua`

- **Fail-open snapshot karşılaştırması kapatıldı.** Önceki ifade `baseline and current ~= baseline` olduğundan, `nil` başlangıç değeri sonradan fonksiyona dönse bile algılanmıyordu. Yeni ifade `baseline ~= current`: `nil`, `false` ve normal fonksiyon kimlikleri karşılaştırılıyor.
- **Düşük öncelikli snapshot'lar dönüşümlü denetleniyor.** Beş temel referans her integrity checkpoint'te; 33 isteğe bağlı referans altılı gruplarla (6 checkpoint) tekrar taranıyor. Bu, her checkpoint'te bütün optional API referanslarının tekrar sorgulanmasını azaltıyor. Gecikmeli tespit değiş tokuşu vardır: isteğe bağlı değişikliklerin bulunması birkaç checkpoint sürebilir.
- **Runtime integrity kritik güvenlik kuralları değişmedi.** Opcode canary, handler ön-yükleme doğrulaması, yedek/pin referansları, VM bytecode ve SEAL4 payload kontrolleri sürüyor. Yeni `identityRotationGroups` istatistiği var.
- Önceden kalmış sürüm assert'leri bulunan `v06_security_regression.lua` ve `v101_luau_bypass_regression.lua` testleri mevcut görünür V0.6 sürümüne uyarlandı; uygulama sürümü değiştirilmedi.

## Test edilen durumlar

| Senaryo | Sonuç |
|---|---|
| İki farklı seed, Sealed + Direct Strong VM9 | PASS |
| Build-time authenticated VM9 audit ve opcode çeşitlendirmesi | PASS |
| Şifreli SEAL4 payload değişikliği | Reddedildi (2 örnek) |
| İki handler tablosunun eş zamanlı müdahalesi | Reddedildi |
| `debug.getregistry` başlangıçta nil, sonra fonksiyon | Yeni: reddedildi; eski: tespit edemedi |
| `debug.traceback` başlangıçta nil, sonra fonksiyon | Yeni: reddedildi |
| Zaten aktif olan normal profiler hook | PASS |
| Kısıtlı/olmayan debug API | PASS |
| Luau sürüm/typeof sahteleme regresyonları (simülasyon) | PASS |
| Chromium .txt web derlemesi | PASS |
| Runtime `load` izleme testi | VM kaynak metni görülebiliyor; orijinal kullanıcı kaynağı ile eşleşmedi |

## Aynı 1.000 satırlık kaynak ve seed=1789 ile performans

| Ölçüm | Önceki | Yeni |
|---|---:|---:|
| Sealed dosya (bayt) | 379.967 | 379.743 |
| Direct VM dosya (bayt) | 295.392 | 294.160 |
| Sealed runtime medyan (3 koşu) | 1.020,4 ms | 989,1 ms |
| Direct VM runtime medyan (3 koşu) | 669,7 ms | 681,7 ms |
| Sealed strict-build duvar süresi (tek ölçüm) | 3.143,4 ms | 3.170,9 ms |
| Direct strict-build duvar süresi (tek ölçüm) | 1.955,9 ms | 1.926,6 ms |

Çalıştırma çıktı hash'leri tüm modlarda aynıdır. Az sayıda ölçüm istatistiksel hızlanma/gerileme garantisi vermez. Compile ve runtime farklı ölçümlerdir.

## Luraph v15.2 karşılaştırması

Ekteki karşılaştırma yazısı Luraph'a statik tersine mühendislik ve kontrol akışı karmaşıklığında küçük avantaj, GsXFuscator'a görünür bütünlük kontrollerinde avantaj veriyor. 9,0 ve 8,8/10 değerleri rapor yazarının **tahmini** puanlarıdır; aynı kaynak kod, aynı cihaz ve bir devirtualization testi üzerinde doğrulanmış skorlar değildir. Kullanıcı tarafından sağlanan Luraph'ın gerçek kaynak/korunmuş örnek baytları elimizde yok; raporda yer alan boyutlar burada bağımsız olarak doğrulanmadı.

Öncelikli sonraki laboratuvar çalışması: iki koruyucunun aynı Lua/Luau programına uygulanması, aynı host'ta doğruluk ve CPU/RAM testi, izinli statik/dinamik VM analizine karşı ortalama kaynak geri kazanımı ve false-positive oranı. Daha çok anti-debug probu veya daha büyük dosya otomatik üstünlük sağlamaz.

## Yeniden üretme

```sh
# Proje kökünde native Lua 5.4 yolu PATH'teyse:
lua5.4 v2/tests/v06_dex_snapshot_regression.lua
lua5.4 v2/tests/vm9_pipeline_proof.lua
GSX_LUA=lua5.4 python3 v2/tests/v06_state_machine_smoke.py
python3 v2/tests/v06_safe_hook_smoke.py --lua lua5.4
python3 web/build.py
python3 v2/tests/v06_seal3_browser_smoke.py
```

**Güvenlik sınırı:** Kullanıcının kontrol etmediği bir Lua runtime'da dağıtılan kodun okunmasını veya gözlemlenmesini kesin olarak önlemek mümkün değildir. Bu yama belli bir bütünlük boşluğunu kapatır; her dumper'ı etkisizleştirmez. Luau/Roblox ve FiveM yerel testleri henüz yapılmadı.
