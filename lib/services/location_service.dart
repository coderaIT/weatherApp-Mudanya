import 'dart:io';

import 'package:geolocator/geolocator.dart';
import '../utils/constants.dart';

/// Konum hatalarını ayırt etmek için dahili kodlar.
class LocationServiceException implements Exception {
  final String code;
  const LocationServiceException(this.code);

  @override
  String toString() => code;
}

/// Cihaz GPS konumunu ve izinlerini yönetir.
class LocationService {
  static const String codeServiceDisabled = 'LOCATION_SERVICE_DISABLED';
  static const String codePermissionDenied = 'LOCATION_PERMISSION_DENIED';
  static const String codePermissionDeniedForever =
      'LOCATION_PERMISSION_DENIED_FOREVER';

  /// Konum servisinin açık olup olmadığını kontrol eder.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Uygulama ayarlarını açar (izin kalıcı reddedildiyse).
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  /// Sistem konum (GPS) ayarlarını açar.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<void> _ensureReady() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(codePermissionDeniedForever);
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(codePermissionDeniedForever);
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(codePermissionDenied);
    }

    if (permission != LocationPermission.always &&
        permission != LocationPermission.whileInUse) {
      throw const LocationServiceException(codePermissionDenied);
    }

    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(codeServiceDisabled);
    }
  }

  /// Cihazın anlık enlem ve boylamını döndürür.
  Future<Position> getCurrentPosition() async {
    await _ensureReady();

    final settings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 25),
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 25),
          );

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );
    } catch (_) {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      throw Exception(AppConstants.errorLocationPermission);
    }
  }
}
