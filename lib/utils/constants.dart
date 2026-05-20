/// Uygulama genelinde kullanılan sabit değerler ve Türkçe metinler.
class AppConstants {
  // OpenWeather API anahtarı — kendi anahtarınızı buraya yazın
  static const String apiKey = '265bb0e0171ac3a4190167a275466b55';

  // One Call API 3.0 — dokümantasyon: openweathermap.org/api/one-call-3
  // https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={key}
  static const String oneCallUrl =
      'https://api.openweathermap.org/data/3.0/onecall';

  // One Call aboneliği yoksa yedek: Current Weather API 2.5
  static const String currentWeatherUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  // Geocoding API — şehir adından koordinat bulma
  static const String geocodingUrl =
      'https://api.openweathermap.org/geo/1.0/direct';

  // Reverse Geocoding — koordinattan şehir adı (GPS için)
  static const String reverseGeocodingUrl =
      'https://api.openweathermap.org/geo/1.0/reverse';

  // Varsayılan şehir: Bursa — uygulama açıldığında gösterilir
  static const String defaultCity = 'Bursa';
  static const double defaultLat = 40.1885;
  static const double defaultLon = 29.0610;

  /// Arama kutusunda gösterilen popüler şehirler (koordinatlı).
  static const List<Map<String, dynamic>> popularCities = [
    {'name': 'Bursa', 'state': 'Bursa', 'country': 'TR', 'lat': 40.1885, 'lon': 29.0610},
    {'name': 'Mudanya', 'state': 'Bursa', 'country': 'TR', 'lat': 40.3763, 'lon': 28.8839},
    {'name': 'İstanbul', 'state': 'İstanbul', 'country': 'TR', 'lat': 41.0082, 'lon': 28.9784},
    {'name': 'Ankara', 'country': 'TR', 'lat': 39.9334, 'lon': 32.8597},
    {'name': 'İzmir', 'state': 'İzmir', 'country': 'TR', 'lat': 38.4237, 'lon': 27.1428},
    {'name': 'Antalya', 'state': 'Antalya', 'country': 'TR', 'lat': 36.8969, 'lon': 30.7133},
    {'name': 'Trabzon', 'state': 'Trabzon', 'country': 'TR', 'lat': 41.0015, 'lon': 39.7178},
    {'name': 'London', 'country': 'GB', 'lat': 51.5074, 'lon': -0.1278},
    {'name': 'Paris', 'country': 'FR', 'lat': 48.8566, 'lon': 2.3522},
    {'name': 'Dubai', 'country': 'AE', 'lat': 25.2048, 'lon': 55.2708},
  ];

  // SQLite veritabanı
  static const String dbName = 'weather_notes.db';
  static const String notesTable = 'notes';

  // Türkçe hata ve bilgi mesajları
  static const String errorGeneral =
      'Veriler yüklenirken bir hata oluştu.';
  static const String errorInternet =
      'İnternet bağlantınızı kontrol edin.';
  static const String errorLocationPermission = 'Konum izni verilmedi.';
  static const String errorLocationPermissionForever =
      'Konum izni kalıcı olarak reddedildi. Ayarlardan uygulamaya izin verin.';
  static const String errorLocationServiceDisabled =
      'Konum servisi kapalı. Telefonunuzda GPS / Konum\'u açın.';
  static const String errorCityNotFound = 'Şehir bulunamadı.';
  static const String errorEmptyCity = 'Lütfen bir şehir adı giriniz.';
  static const String errorEmptyNote = 'Lütfen bir not yazınız.';
  static const String errorInvalidApiKey =
      'Geçersiz API anahtarı. constants.dart dosyasına OpenWeather anahtarınızı yazın.';
  static const String errorApiSubscription =
      'One Call API 3.0 aboneliği gerekli. OpenWeather hesabınızdan etkinleştirin.';

  // Uygulama başlığı
  static const String appTitle = 'Hava Durumu Notları';

  /// API anahtarının ayarlanıp ayarlanmadığını kontrol eder.
  static bool get isApiKeyConfigured =>
      apiKey.isNotEmpty &&
      apiKey != 'PUT_THE_OPENWEATHER_API_KEY_HERE';
}
