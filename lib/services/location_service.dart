import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';

/// Cihaz GPS konumunu ve izinlerini yönetir.
class LocationService {
  /// Konum servisinin açık olup olmadığını kontrol eder.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Konum iznini kontrol eder; gerekirse kullanıcıdan ister.
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Cihazın anlık enlem ve boylamını döndürür.
  Future<Position> getCurrentPosition() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Konum servisi kapalı.');
      }

      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw Exception(AppConstants.errorLocationPermission);
      }

      // GPS ile mevcut konumu al
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
