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

  // SQLite veritabanı
  static const String dbName = 'weather_notes.db';
  static const String notesTable = 'notes';

  // Türkçe hata ve bilgi mesajları
  static const String errorGeneral =
      'Veriler yüklenirken bir hata oluştu.';
  static const String errorInternet =
      'İnternet bağlantınızı kontrol edin.';
  static const String errorLocationPermission = 'Konum izni verilmedi.';
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
