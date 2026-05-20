import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constants.dart';

/// OpenWeather Geocoding ve One Call API 3.0 çağrılarını yönetir.
/// Dokümantasyon: https://openweathermap.org/api/one-call-3
class WeatherApiService {
  static const Duration _timeout = Duration(seconds: 15);

  /// API anahtarı girilmiş mi kontrol eder.
  void _ensureApiKeyConfigured() {
    if (!AppConstants.isApiKeyConfigured) {
      throw Exception(AppConstants.errorInvalidApiKey);
    }
  }

  /// OpenWeather hata JSON'ını okur: {"cod":401,"message":"..."}
  String? _parseApiErrorMessage(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String?;
    } catch (_) {
      return null;
    }
  }

  /// HTTP hata kodlarını anlamlı Türkçe mesaja çevirir (her zaman throw eder).
  Never _handleErrorResponse(http.Response response) {
    final apiMessage = _parseApiErrorMessage(response.body);

    if (response.statusCode == 401) {
      // One Call 3.0 ayrı "One Call by Call" aboneliği gerektirir
      if (apiMessage != null &&
          apiMessage.toLowerCase().contains('one call')) {
        throw Exception(AppConstants.errorApiSubscription);
      }
      throw Exception(AppConstants.errorInvalidApiKey);
    }
    if (response.statusCode == 403) {
      throw Exception(AppConstants.errorApiSubscription);
    }
    if (response.statusCode == 404) {
      throw Exception(AppConstants.errorCityNotFound);
    }
    if (response.statusCode == 429) {
      throw Exception('API istek limiti aşıldı. Lütfen biraz bekleyin.');
    }
    throw Exception(apiMessage ?? 'API hatası: ${response.statusCode}');
  }

  /// One Call API 3.0 ile anlık hava durumu.
  /// exclude=minutely,hourly,daily,alerts — sadece current verisi
  Future<WeatherModel> fetchWeatherByCoordinates({
    required double lat,
    required double lon,
    required String cityName,
  }) async {
    _ensureApiKeyConfigured();

    try {
      final uri = Uri.parse(AppConstants.oneCallUrl).replace(
        queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          // Dokümantasyona göre virgülle ayrılmış, boşluksuz
          'exclude': 'minutely,hourly,daily,alerts',
          'units': 'metric',
          'lang': 'tr',
          'appid': AppConstants.apiKey,
        },
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromOneCallJson(json, cityName);
      }

      // One Call aboneliği yoksa Current Weather 2.5 ile yedekle
      if (response.statusCode == 401) {
        final msg = _parseApiErrorMessage(response.body) ?? '';
        if (msg.toLowerCase().contains('one call')) {
          return _fetchCurrentWeatherFallback(lat, lon, cityName);
        }
      }

      _handleErrorResponse(response);
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(AppConstants.errorInternet);
    }
  }

  /// Current Weather API 2.5 — One Call 3.0 aboneliği olmayan hesaplar için.
  Future<WeatherModel> _fetchCurrentWeatherFallback(
    double lat,
    double lon,
    String cityName,
  ) async {
    final uri = Uri.parse(AppConstants.currentWeatherUrl).replace(
      queryParameters: {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'units': 'metric',
        'lang': 'tr',
        'appid': AppConstants.apiKey,
      },
    );

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final model = WeatherModel.fromCurrentWeatherJson(json);
      // Geocoding'den gelen şehir adını koru
      if (cityName.isNotEmpty) {
        return WeatherModel(
          temperature: model.temperature,
          feelsLike: model.feelsLike,
          humidity: model.humidity,
          windSpeed: model.windSpeed,
          description: model.description,
          iconCode: model.iconCode,
          cityName: cityName,
        );
      }
      return model;
    }
    _handleErrorResponse(response);
  }

  /// Geocoding API — şehir adından koordinat bulma.
  Future<Map<String, dynamic>> getCoordinatesByCity(String cityName) async {
    _ensureApiKeyConfigured();

    try {
      final uri = Uri.parse(AppConstants.geocodingUrl).replace(
        queryParameters: {
          'q': cityName,
          'limit': '1',
          'appid': AppConstants.apiKey,
        },
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isEmpty) {
          throw Exception(AppConstants.errorCityNotFound);
        }
        final location = data.first as Map<String, dynamic>;
        return {
          'lat': (location['lat'] as num).toDouble(),
          'lon': (location['lon'] as num).toDouble(),
          'name': location['name'] as String? ?? cityName,
        };
      } else {
        _handleErrorResponse(response);
      }
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(AppConstants.errorInternet);
    }
  }

  /// Şehir adı ile önce geocoding, sonra hava durumu getirir.
  Future<WeatherModel> fetchWeatherByCity(String cityName) async {
    final coords = await getCoordinatesByCity(cityName);
    return fetchWeatherByCoordinates(
      lat: coords['lat'] as double,
      lon: coords['lon'] as double,
      cityName: coords['name'] as String,
    );
  }

  /// Reverse Geocoding — GPS koordinatlarından şehir adı.
  Future<String> getCityNameFromCoordinates(double lat, double lon) async {
    if (!AppConstants.isApiKeyConfigured) {
      return 'Konumunuz';
    }

    try {
      final uri = Uri.parse(AppConstants.reverseGeocodingUrl).replace(
        queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'limit': '1',
          'appid': AppConstants.apiKey,
        },
      );

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        if (data.isNotEmpty) {
          final location = data.first as Map<String, dynamic>;
          return location['name'] as String? ?? 'Konumunuz';
        }
      }
      return 'Konumunuz';
    } catch (_) {
      return 'Konumunuz';
    }
  }
}
