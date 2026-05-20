import 'package:flutter/foundation.dart';
import '../models/city_suggestion.dart';
import '../models/weather_model.dart';
import '../services/location_service.dart' show LocationService, LocationServiceException;
import '../services/weather_api_service.dart';
import '../utils/constants.dart';

/// Hava durumu verisi, yükleme ve hata durumlarını yönetir.
/// Ana sayfa ve arama ekranı için ayrı state tutulur (birbirini ezmez).
class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _apiService = WeatherApiService();
  final LocationService _locationService = LocationService();

  // Ana sayfa state
  WeatherModel? _homeWeather;
  bool _homeLoading = false;
  String? _homeError;

  // Arama ekranı state
  WeatherModel? _searchWeather;
  bool _searchLoading = false;
  String? _searchError;

  WeatherModel? get homeWeather => _homeWeather;
  bool get homeIsLoading => _homeLoading;
  String? get homeErrorMessage => _homeError;

  WeatherModel? get searchWeather => _searchWeather;
  bool get searchIsLoading => _searchLoading;
  String? get searchErrorMessage => _searchError;

  /// Önce GPS, izin yoksa veya hata olursa varsayılan şehir (Bursa).
  Future<void> loadHomeWeather() async {
    _homeLoading = true;
    _homeError = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      final cityName = await _apiService.getCityNameFromCoordinates(
        position.latitude,
        position.longitude,
      );
      _homeWeather = await _apiService.fetchWeatherByCoordinates(
        lat: position.latitude,
        lon: position.longitude,
        cityName: cityName,
      );
      _homeError = null;
    } catch (_) {
      try {
        _homeWeather = await _apiService.fetchWeatherByCoordinates(
          lat: AppConstants.defaultLat,
          lon: AppConstants.defaultLon,
          cityName: AppConstants.defaultCity,
        );
        _homeError = null;
      } catch (e) {
        _homeError = _parseError(e);
        _homeWeather = null;
      }
    } finally {
      _homeLoading = false;
      notifyListeners();
    }
  }

  /// Varsayılan şehir (Bursa) hava durumunu yükler.
  Future<void> loadDefaultWeather() async {
    await _fetchHomeWeather(
      () => _apiService.fetchWeatherByCoordinates(
        lat: AppConstants.defaultLat,
        lon: AppConstants.defaultLon,
        cityName: AppConstants.defaultCity,
      ),
    );
  }

  /// GPS konumundan ana sayfa hava durumu getirir.
  Future<void> fetchWeatherByGps() async {
    _homeLoading = true;
    _homeError = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      final cityName = await _apiService.getCityNameFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _homeWeather = await _apiService.fetchWeatherByCoordinates(
        lat: position.latitude,
        lon: position.longitude,
        cityName: cityName,
      );
      _homeError = null;
    } catch (e) {
      _homeError = _parseError(e);
    } finally {
      _homeLoading = false;
      notifyListeners();
    }
  }

  /// Yazılan metne göre şehir önerileri.
  Future<List<CitySuggestion>> searchCitySuggestions(String query) {
    return _apiService.searchCitySuggestions(query);
  }

  /// Önerilen şehirden hava durumu getirir.
  Future<void> fetchWeatherBySuggestion(CitySuggestion city) async {
    _searchLoading = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchWeather = await _apiService.fetchWeatherBySuggestion(city);
      _searchError = null;
    } catch (e) {
      _searchError = _parseError(e);
      _searchWeather = null;
    } finally {
      _searchLoading = false;
      notifyListeners();
    }
  }

  /// Şehir adı ile arama ekranında hava durumu getirir.
  Future<void> fetchWeatherByCity(String cityName) async {
    _searchLoading = true;
    _searchError = null;
    notifyListeners();

    try {
      _searchWeather = await _apiService.fetchWeatherByCity(cityName.trim());
      _searchError = null;
    } catch (e) {
      _searchError = _parseError(e);
      _searchWeather = null;
    } finally {
      _searchLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchHomeWeather(Future<WeatherModel> Function() fetcher) async {
    _homeLoading = true;
    _homeError = null;
    notifyListeners();

    try {
      _homeWeather = await fetcher();
      _homeError = null;
    } catch (e) {
      _homeError = _parseError(e);
    } finally {
      _homeLoading = false;
      notifyListeners();
    }
  }

  bool get homeErrorNeedsAppSettings =>
      _homeError == AppConstants.errorLocationPermissionForever;

  bool get homeErrorNeedsLocationService =>
      _homeError == AppConstants.errorLocationServiceDisabled;

  /// Hata mesajını Türkçe ve kullanıcı dostu hale getirir.
  String _parseError(Object e) {
    if (e is LocationServiceException) {
      switch (e.code) {
        case LocationService.codeServiceDisabled:
          return AppConstants.errorLocationServiceDisabled;
        case LocationService.codePermissionDeniedForever:
          return AppConstants.errorLocationPermissionForever;
        case LocationService.codePermissionDenied:
          return AppConstants.errorLocationPermission;
      }
    }

    final message = e.toString();

    if (message.contains(AppConstants.errorInvalidApiKey)) {
      return AppConstants.errorInvalidApiKey;
    }
    if (message.contains(AppConstants.errorApiSubscription)) {
      return AppConstants.errorApiSubscription;
    }
    if (message.contains(AppConstants.errorLocationPermissionForever) ||
        message.contains('LOCATION_PERMISSION_DENIED_FOREVER') ||
        message.contains('deniedForever')) {
      return AppConstants.errorLocationPermissionForever;
    }
    if (message.contains(AppConstants.errorLocationServiceDisabled) ||
        message.contains('LOCATION_SERVICE_DISABLED') ||
        message.contains('Konum servisi kapalı')) {
      return AppConstants.errorLocationServiceDisabled;
    }
    if (message.contains(AppConstants.errorLocationPermission) ||
        message.contains('LOCATION_PERMISSION_DENIED') ||
        message.contains('Konum izni')) {
      return AppConstants.errorLocationPermission;
    }
    if (message.contains(AppConstants.errorCityNotFound)) {
      return AppConstants.errorCityNotFound;
    }
    if (message.contains('SocketException') ||
        message.contains('Failed host lookup') ||
        message.contains('TimeoutException') ||
        message.contains('Network')) {
      return AppConstants.errorInternet;
    }
    return AppConstants.errorGeneral;
  }
}
