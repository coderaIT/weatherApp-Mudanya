# Hava Durumu Notları — Detaylı Proje Sunumu

**Proje adı:** Hava Durumu Notları (weatherApp-Mudanya)  
**Tür:** Üniversite dönem projesi — mobil uygulama  
**Platform:** Android (fiziksel cihazda test)  
**Geliştirme ortamı:** Flutter · Visual Studio Code / Cursor · Windows 11  
**Hazırlayan:** [Adınızı ve öğrenci numaranızı yazın]  
**Danışman:** [Varsa hoca adı]  
**Tarih:** Mayıs 2026

---

## İçindekiler

1. [Giriş ve Problem Tanımı](#1-giriş-ve-problem-tanımı)  
2. [Proje Kapsamı ve Hedefler](#2-proje-kapsamı-ve-hedefler)  
3. [Kullanılan Teknolojiler](#3-kullanılan-teknolojiler)  
4. [Sistem Mimarisi ve Klasör Yapısı](#4-sistem-mimarisi-ve-klasör-yapısı)  
5. [Ekranlar ve Kullanıcı Deneyimi](#5-ekranlar-ve-kullanıcı-deneyimi)  
6. [OpenWeather API Entegrasyonu](#6-openweather-api-entegrasyonu)  
7. [Konum (GPS) Modülü](#7-konum-gps-modülü)  
8. [Şehir Arama ve Otomatik Tamamlama](#8-şehir-arama-ve-otomatik-tamamlama)  
9. [Animasyonlu Hava Durumu Görselleri](#9-animasyonlu-hava-durumu-görselleri)  
10. [Notlar Modülü ve SQLite](#10-notlar-modülü-ve-sqlite)  
11. [Arayüz Tasarımı ve Bileşenler](#11-arayüz-tasarımı-ve-bileşenler)  
12. [Android Yapılandırması ve İzinler](#12-android-yapılandırması-ve-izinler)  
13. [Geliştirme ve Test Süreci](#13-geliştirme-ve-test-süreci)  
14. [Karşılaşılan Sorunlar ve Çözümler](#14-karşılaşılan-sorunlar-ve-çözümler)  
15. [Sonuç, Kazanımlar ve Gelecek Çalışmalar](#15-sonuç-kazanımlar-ve-gelecek-çalışmalar)  
16. [Sunum Konuşma Metni](#16-sunum-konuşma-metni)  
17. [Kaynakça](#17-kaynakça)

---

## 1. Giriş ve Problem Tanımı

Günümüzde kullanıcılar hava durumunu sıklıkla mobil cihazlardan takip etmektedir. Ancak birçok uygulama ya yalnızca tek şehre odaklanmakta ya da kullanıcıya not tutma gibi kişisel özellikler sunmamaktadır. **Hava Durumu Notları** projesi, bu ihtiyaca yanıt vermek üzere tasarlanmıştır: hem **canlı meteorolojik veri** sunar hem de kullanıcının gözlemlediği hava koşullarıyla ilgili **yerel notlar** kaydetmesine imkân tanır.

Proje, Bursa ve çevresi (özellikle **Mudanya**) gibi bölgeleri düşünerek Türkçe arayüz ve yerel şehir önerileri ile geliştirilmiştir. Üniversite dönem çalışması olarak hem yazılım mühendisliği prensiplerini (katmanlı mimari, API entegrasyonu, yerel veritabanı) hem de mobil geliştirme pratiğini bir arada göstermeyi amaçlar.

---

## 2. Proje Kapsamı ve Hedefler

### 2.1 Temel Hedefler

| # | Hedef | Durum |
|---|--------|--------|
| 1 | Flutter ile çok platforma hazır mobil arayüz | ✅ Tamamlandı |
| 2 | OpenWeather API ile gerçek zamanlı hava verisi | ✅ Tamamlandı |
| 3 | Varsayılan şehir olarak Bursa gösterimi | ✅ Tamamlandı |
| 4 | GPS ile «konumuma göre» hava sorgusu | ✅ Tamamlandı |
| 5 | Şehir adı ile arama + yazarken öneri listesi | ✅ Tamamlandı |
| 6 | Tüm hava tipleri için animasyonlu gösterim | ✅ Tamamlandı |
| 7 | SQLite ile offline not saklama | ✅ Tamamlandı |
| 8 | Türkçe hata ve bilgi mesajları | ✅ Tamamlandı |
| 9 | Android fiziksel cihazda test | ✅ Tamamlandı |

### 2.2 Kapsam Dışı (Bu Sürümde Yok)

- Haftalık / saatlik tahmin (forecast) ekranı  
- Push bildirimleri  
- Kullanıcı hesabı ve bulut senkronizasyonu  
- Harita üzerinde hava gösterimi  

Bu özellikler «gelecek sürüm» olarak planlanmıştır.

---

## 3. Kullanılan Teknolojiler

### 3.1 Ön Yüz ve Çerçeve

- **Flutter 3.x** — Google’ın UI toolkit’i; tek kod tabanından Android, iOS, Web ve masaüstü hedeflenebilir.  
- **Dart 3.11** — Güçlü tip sistemi ve async/await ile API çağrıları.  
- **Material Design 3** — Modern kartlar, navigasyon çubuğu, tutarlı renk paleti (`#3949AB` ana renk).

### 3.2 Durum Yönetimi

- **Provider** paketi — `ChangeNotifier` tabanlı; `WeatherProvider` ve `NotesProvider` ile ekranların ihtiyacı olan veriyi dinlemesi. Ana sayfa ve arama ekranı için **ayrı state** tutulur; bir ekrandaki arama sonucu diğerini ezmez.

### 3.3 Ağ ve Veri Kaynakları

- **http** — REST API istekleri.  
- **OpenWeather Map API:**  
  - One Call API 3.0 (birincil)  
  - Current Weather API 2.5 (yedek)  
  - Geocoding API (şehir → koordinat, koordinat → şehir adı)  
- **intl** — Türkçe tarih formatı (`tr_TR`) notlar ekranında.

### 3.4 Cihaz Özellikleri

- **geolocator** — GPS konumu, izin kontrolü, ayarları açma.  
- **sqflite** + **path** — Yerel SQLite veritabanı (`weather_notes.db`).

### 3.5 Geliştirme Araçları

- `flutter run`, hot reload, DevTools  
- `.vscode/launch.json` — Chrome, Windows ve cihaz profilleri  
- Gradle / Android SDK — APK derleme ve USB debug

---

## 4. Sistem Mimarisi ve Klasör Yapısı

### 4.1 Katmanlı Mimari

```
┌─────────────────────────────────────────┐
│  UI Katmanı (Screens + Widgets)         │
├─────────────────────────────────────────┤
│  State Katmanı (Providers)              │
├─────────────────────────────────────────┤
│  İş Mantığı (Services)                  │
├─────────────────────────────────────────┤
│  Veri (Models + SQLite + HTTP API)      │
└─────────────────────────────────────────┘
```

**Akış örneği (şehir arama):**  
Kullanıcı şehir yazar → `SearchScreen` → `WeatherProvider.fetchWeatherByCity()` → `WeatherApiService.getCoordinatesByCity()` → `fetchWeatherByCoordinates()` → `WeatherModel` → `WeatherCard` güncellenir.

### 4.2 Proje Klasör Yapısı (`lib/`)

| Dosya / Klasör | Görevi |
|----------------|--------|
| `main.dart` | Uygulama girişi, Provider kaydı, alt menü |
| `screens/home_screen.dart` | Ana sayfa, Bursa varsayılan, GPS butonu |
| `screens/search_screen.dart` | Şehir arama ve sonuç kartı |
| `screens/notes_screen.dart` | Not ekleme, listeleme, silme |
| `providers/weather_provider.dart` | Hava verisi, yükleme, hata mesajları |
| `providers/notes_provider.dart` | Not CRUD işlemleri |
| `services/weather_api_service.dart` | Tüm OpenWeather HTTP çağrıları |
| `services/location_service.dart` | GPS ve izin yönetimi |
| `services/database_service.dart` | SQLite işlemleri |
| `models/weather_model.dart` | Sıcaklık, nem, ikon kodu vb. |
| `models/note_model.dart` | Not içeriği ve tarih |
| `models/city_suggestion.dart` | Arama önerisi satırı |
| `widgets/weather_card.dart` | Hava özet kartı |
| `widgets/weather_animation.dart` | Animasyon seçici |
| `widgets/builtin_weather_animations.dart` | CustomPaint sahneleri |
| `widgets/city_autocomplete_field.dart` | Yazarken öneri listesi |
| `utils/constants.dart` | API URL, Bursa koordinatları, Türkçe metinler |
| `utils/weather_condition.dart` | İkon kodu → animasyon türü |

Bu düzen, **bakımı kolay** ve sunumda «modüler yapı» olarak anlatılabilir bir yapı sunar.

---

## 5. Ekranlar ve Kullanıcı Deneyimi

### 5.1 Ana Navigasyon

Uygulama açıldığında `MainNavigationScreen` üç sekmeli alt çubuk gösterir:

1. **Ana Sayfa** (ev ikonu)  
2. **Şehir Ara** (büyüteç ikonu)  
3. **Notlar** (not defteri ikonu)  

Sadece aktif sekme build edilir; gereksiz API ve veritabanı çağrısı önlenir.

### 5.2 Ana Sayfa (`HomeScreen`)

- **Açılış davranışı:** Otomatik olarak **Bursa** için hava durumu yüklenir (`loadDefaultWeather`).  
- **Gösterilen bilgiler:** Şehir adı, animasyonlu hava görseli, açıklama, sıcaklık (°C), hissedilen, nem (%), rüzgar (m/s).  
- **GPS butonu:** «Konumuma Göre Hava Durumunu Getir» — kullanıcı izin verirse anlık konumdan hava çekilir; reverse geocoding ile şehir adı bulunur.  
- **Hata durumu:** Kırmızı bilgi kartı, yenileme ve gerekirse «Uygulama ayarlarını aç» / «Konum ayarlarını aç» butonları.

### 5.3 Şehir Ara (`SearchScreen`)

- Metin alanına yazıldıkça **öneri paneli** açılır.  
- Boşken: Bursa, Mudanya, İstanbul, Ankara, İzmir, Antalya, Trabzon, Londra, Paris, Dubai.  
- 2+ karakterde: OpenWeather Geocoding’den en fazla 8 sonuç + popüler şehirler birleştirilir.  
- Öneriye dokunulunca doğrudan o koordinattan hava yüklenir.  
- «Hava Durumunu Getir» butonu ile manuel arama da yapılabilir.

### 5.4 Notlar (`NotesScreen`)

- Çok satırlı metin alanı + «Not Ekle» butonu.  
- Notlar **yeniden eskiye** listelenir; Türkçe tarih formatı.  
- Her notta silme (çöp kutusu) ikonu.  
- Veriler yalnızca cihazda; internet gerekmez.

---

## 6. OpenWeather API Entegrasyonu

### 6.1 Kullanılan Uç Noktalar

| API | URL | Amaç |
|-----|-----|------|
| One Call 3.0 | `data/3.0/onecall` | Anlık hava (current) |
| Current Weather 2.5 | `data/2.5/weather` | Abonelik yoksa yedek |
| Geocoding Direct | `geo/1.0/direct` | Şehir adı → lat/lon |
| Geocoding Reverse | `geo/1.0/reverse` | lat/lon → şehir adı |

Parametreler: `units=metric`, `lang=tr`, `appid=API_KEY`.

### 6.2 Veri Modeli (`WeatherModel`)

API yanıtından parse edilen alanlar:

- `temperature`, `feelsLike` (°C)  
- `humidity` (%), `windSpeed` (m/s)  
- `description` (Türkçe metin)  
- `iconCode` (ör. `10d`, `01n`) — animasyon seçimi için  
- `cityName` — ekranda başlık  

### 6.3 Hata Yönetimi

`WeatherApiService` HTTP kodlarına göre Türkçe exception fırlatır; `WeatherProvider._parseError()` bunları kullanıcı dostu metne çevirir:

- 401 → Geçersiz API anahtarı veya One Call aboneliği  
- 404 → Şehir bulunamadı  
- Ağ hatası → İnternet bağlantısı uyarısı  
- Zaman aşımı → 15 saniye `timeout`

---

## 7. Konum (GPS) Modülü

### 7.1 `LocationService` İş Akışı

1. Konum servisi açık mı? (`isLocationServiceEnabled`)  
2. İzin durumu: `denied` → `requestPermission()`  
3. `deniedForever` → ayarlara yönlendirme mesajı  
4. `getCurrentPosition` — Android’de yüksek doğruluk, 25 sn limit  
5. Başarısızsa `getLastKnownPosition` yedek  

### 7.2 Kullanıcı Mesajları (Ayrıştırılmış)

| Durum | Mesaj |
|--------|--------|
| İzin verilmedi | Konum izni verilmedi. |
| Kalıcı red | Ayarlardan uygulamaya izin verin. |
| GPS kapalı | Telefonunuzda GPS / Konum'u açın. |

Bu ayrım, kullanıcının «izin verdim ama yine hata» karmaşasını azaltır.

---

## 8. Şehir Arama ve Otomatik Tamamlama

### 8.1 `CityAutocompleteField` Özellikleri

- **Debounce:** 350 ms — her tuşta API çağrısı yapılmaz.  
- **Focus:** Alana tıklanınca öneri paneli açılır.  
- **Temizleme:** X ikonu ile metin silinir, öneriler yenilenir.  
- **Seçim:** `onSuggestionSelected` → `fetchWeatherBySuggestion` (koordinat hazır, ek geocoding gerekmez).

### 8.2 Popüler Şehirler (`AppConstants.popularCities`)

Koordinatları önceden tanımlı 10 şehir; API gecikmesinde veya kısa sorgularda hızlı sonuç sağlar. Mudanya ve Bursa listenin başında yer alır.

### 8.3 Türkçe Karakter Desteği

Arama normalizasyonu: ı→i, ş→s, ğ→g vb. ile «istanbul» yazılsa bile «İstanbul» eşleşir.

---

## 9. Animasyonlu Hava Durumu Görselleri

### 9.1 Neden Yerleşik Animasyon?

İlk sürümde Lottie JSON dosyaları kullanılmıştı; ancak `storm.json` dosyası aslında bir **yükleniyor** animasyonuydu ve bazı dosyalar erişim hatası veriyordu. Bu nedenle tüm hava tipleri için **Flutter CustomPaint** ile çizilen sahneler geliştirildi — internete bağımlı değil, her cihazda tutarlı.

### 9.2 OpenWeather İkon Kodları ve Karşılıkları

| Kod | Anlam | Animasyon |
|-----|--------|-----------|
| 01d / 01n | Açık | Dönen güneş ışınları / ay ve yıldızlar |
| 02d / 02n | Az bulutlu | Güneş veya ay + sürüklenen bulutlar |
| 03 | Dağınık bulutlu | Bulutlar |
| 04 | Kapalı | Yoğun bulut katmanları |
| 09 | Çisenti | Bulut + hafif yağmur çizgileri |
| 10 | Yağmur | Bulut + yağmur |
| 11 | Fırtına | Koyu bulut + yağmur + şimşek flaşı |
| 13 | Kar | Bulut + düşen kar taneleri |
| 50 | Sis | Yatay sis bantları (opacity animasyonu) |

### 9.3 Yedek Mantık (`WeatherConditionParser`)

İkon kodu boş veya tanınmazsa `description` alanından Türkçe/İngilizce anahtar kelime ile tür belirlenir (ör. «yağmur», «kar», «fırtına»).

---

## 10. Notlar Modülü ve SQLite

### 10.1 Veritabanı Şeması

**Dosya:** `weather_notes.db`  
**Tablo:** `notes`

| Sütun | Tip | Açıklama |
|--------|-----|----------|
| id | INTEGER PK | Otomatik artan |
| content | TEXT | Not metni |
| createdAt | TEXT | ISO tarih string |

### 10.2 İşlemler

- `getNotes()` — DESC sıralı liste  
- `insertNote()` — boş not engellenir (`NotesProvider`)  
- `deleteNote()` — tek dokunuşla silme  

Notlar modülü hava API’sinden **bağımsızdır**; offline çalışır.

---

## 11. Arayüz Tasarımı ve Bileşenler

| Bileşen | Rol |
|---------|-----|
| `GradientBackground` | Mor-mavi degrade arka plan, tüm sekmelerde tutarlılık |
| `WeatherCard` | Beyaz yarı saydam kart, gölge, hava özeti |
| `CustomButton` | Yükleme göstergeli birincil butonlar |
| `LoadingWidget` | Dönen indicator + Türkçe mesaj |
| `ErrorDisplayWidget` | Hata metni, yenile, isteğe bağlı ayar butonu |

Tasarım hedefi: **sade, okunaklı, öğrenci projesine uygun** profesyonel görünüm.

---

## 12. Android Yapılandırması ve İzinler

`AndroidManifest.xml` içinde tanımlı izinler:

- `INTERNET` — API çağrıları  
- `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` — GPS  
- `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_LOCATION` — Geolocator uyumluluğu (Android 14+)  

Uygulama etiketi: **Hava Durumu Notları**  
Paket: `com.example.flutter_project`  

Derleme: `flutter run -d <cihaz_id>` ile Samsung Android 11 cihazda test edilmiştir.

---

## 13. Geliştirme ve Test Süreci

1. **Kurulum:** Flutter SDK, Android SDK, USB hata ayıklama açık telefon.  
2. **Bağımlılıklar:** `flutter pub get`  
3. **Geliştirme döngüsü:** Kod değişikliği → hot reload (`r`) veya hot restart (`R`).  
4. **İlk derleme:** Gradle `assembleDebug`, NDK ve Build-Tools otomatik indirildi (~4 dk).  
5. **Doğrulama:** Ana sayfa Bursa, arama önerileri, GPS, animasyonlar, not ekleme/silme manuel test.  
6. **Statik analiz:** `flutter analyze lib` — hata yok.

---

## 14. Karşılaşılan Sorunlar ve Çözümler

| # | Sorun | Teknik neden | Uygulanan çözüm |
|---|--------|----------------|------------------|
| 1 | Code Runner ile binlerce hata | Dart VM ile Flutter widget ağacı çalışmaz | `flutter run` veya VS Code Dart/Flutter F5 |
| 2 | Windows’ta derleme symlink hatası | Plugin’ler symlink ister | Android cihazda derleme; Developer Mode önerisi |
| 3 | «Konum izni verilmedi» GPS kapalıyken de | Tek hata mesajı | Ayrı `LocationServiceException` kodları |
| 4 | GPS izni kalıcı red | Android «bir daha sorma» | `openAppSettings()` butonu |
| 5 | Bozuk fırtına animasyonu | Yanlış Lottie dosyası | CustomPaint fırtına sahnesi |
| 6 | Varsayılan bilinmeyen bulut ikonu | Eksik ikon eşlemesi | 01–50 tam tablo + description fallback |
| 7 | Şehir arama zayıf UX | Sadece TextField | Autocomplete + popüler şehirler |
| 8 | USB bağlantısı koptu | `flutter run` oturumu kapandı | Yeniden `flutter run -d R3CM809YL1B` |

Bu tablo sunumda «problem çözme becerisi» olarak vurgulanabilir.

---

## 15. Sonuç, Kazanımlar ve Gelecek Çalışmalar

### 15.1 Sonuç

**Hava Durumu Notları**, dönem projesi gereksinimlerini karşılayan, gerçek API verisi kullanan, konum ve arama özellikleri olan, görsel olarak zengin ve yerel not desteği sunan **tam işlevli bir Android uygulamasıdır**.

### 15.2 Kazanımlar (Öğrenci Perspektifi)

- Flutter widget ağacı ve state yönetimi pratiği  
- REST API entegrasyonu ve JSON parse  
- Mobil izin (runtime permission) deneyimi  
- SQLite ile kalıcı yerel veri  
- CustomPaint ile özel çizim / animasyon  
- Hata ayıklama ve fiziksel cihaz testi  

### 15.3 Gelecek Sürüm Önerileri

1. **5 günlük tahmin** — OpenWeather forecast API  
2. **Favori şehirler** — SharedPreferences veya SQLite  
3. **Karanlık tema** — `ThemeMode.dark`  
4. **Widget / bildirim** — sabah hava özeti  
5. **iOS test ve mağaza yayını**  
6. **API anahtarını `.env` ile gizleme** — güvenlik iyileştirmesi  

---

## 16. Sunum Konuşma Metni

### Kısa versiyon (~45 saniye)

«Sayın hocam ve arkadaşlar, projemizin adı **Hava Durumu Notları**. Flutter ve Dart ile geliştirdik. OpenWeather API’den canlı veri çekiyoruz; uygulama açılınca varsayılan olarak **Bursa** gösteriliyor. Kullanıcı isterse GPS ile kendi konumunu, isterse şehir arama ekranından yazarken çıkan önerilerden bir şehri seçebiliyor. Her hava tipi için kendi animasyonumuz var — güneş, yağmur, kar, fırtına gibi. Ayrıca SQLite ile internetsiz not tutulabiliyor. Projeyi Android telefonda USB ile test ettik. Katmanlı mimari ve Türkçe arayüz kullandık. Dinlediğiniz için teşekkürler.»

### Uzun versiyon (~2 dakika)

«Projemize hoş geldiniz. Bu çalışma, hava durumunu takip etmek isteyen kullanıcılar için tasarlandı. Teknik tarafta **Flutter** seçtik çünkü hem hızlı arayüz geliştirmeye hem de ileride iOS’a taşımaya uygun.

Uygulamamız üç ana bölümden oluşuyor. **Ana sayfada** Bursa’nın anlık havasını görüyorsunuz; sıcaklık, nem, rüzgar ve Türkçe açıklama var. **Konumuma göre** butonu ile telefonun GPS’inden koordinat alıp o bölgenin havasını getiriyoruz; izin ve kapalı GPS için ayrı uyarılar gösteriyoruz.

**Şehir arama** ekranında yazdıkça API’den ve önceden tanımlı popüler şehirlerden öneri listesi çıkıyor — Mudanya ve İstanbul gibi. Listeden seçince doğrudan hava kartı güncelleniyor.

Görsel olarak statik ikon yerine **animasyonlu sahneler** kullandık: CustomPaint ile çizilen güneş, bulut, yağmur, kar ve şimşek. Böylece tüm OpenWeather kodları karşılanıyor.

**Notlar** sekmesinde kullanıcı kişisel gözlemlerini SQLite’a kaydediyor; internet olmadan da çalışıyor.

Geliştirme sırasında Code Runner hatası, konum izni ve bozuk animasyon dosyası gibi sorunları çözdük; son testleri Samsung Android cihazda yaptık.

Özetle proje hem yazılım mimarisi hem kullanıcı deneyimi açısından dönem hedeflerimizi karşılıyor. Sorularınızı memnuniyetle yanıtlarız. Teşekkürler.»

---

## 17. Kaynakça

1. Flutter Documentation — https://docs.flutter.dev  
2. OpenWeather Map API — https://openweathermap.org/api  
3. Provider package — https://pub.dev/packages/provider  
4. Geolocator plugin — https://pub.dev/packages/geolocator  
5. sqflite — https://pub.dev/packages/sqflite  
6. Dart language tour — https://dart.dev/guides  

---

## Ek: Slayt Bölünmesi Önerisi (10–12 slayt)

| Slayt | Başlık |
|-------|--------|
| 1 | Kapak — proje adı, isim, tarih |
| 2 | Problem ve amaç |
| 3 | Teknolojiler tablosu |
| 4 | Mimari diyagram |
| 5 | Ana sayfa ekran görüntüsü |
| 6 | Şehir arama + öneriler |
| 7 | Animasyon örnekleri (4 hava tipi) |
| 8 | Notlar + SQLite |
| 9 | API akış şeması |
| 10 | GPS ve izinler |
| 11 | Sorunlar ve çözümler |
| 12 | Sonuç ve teşekkür |

---

*Belge uzatılmış sunum sürümüdür. Word’e yapıştırıldığında yaklaşık 5–7 sayfa (Arial 11, 1,15 satır aralığı) oluşturur.*
