import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/location_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_widget.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_widget.dart';
import '../widgets/weather_card.dart';

/// Ana Sayfa — varsayılan veya GPS hava durumu.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    // Sayfa açılınca varsayılan şehir hava durumunu yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WeatherProvider>().loadDefaultWeather();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppConstants.appTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Ana Sayfa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (provider.homeIsLoading)
                    const Padding(
                      padding: EdgeInsets.all(48),
                      child: LoadingWidget(
                        message: 'Hava durumu yükleniyor...',
                      ),
                    )
                  else if (provider.homeErrorMessage != null)
                    ErrorDisplayWidget(
                      message: provider.homeErrorMessage!,
                      onRetry: () => provider.loadDefaultWeather(),
                      settingsButtonLabel: provider.homeErrorNeedsAppSettings
                          ? 'Uygulama ayarlarını aç'
                          : provider.homeErrorNeedsLocationService
                              ? 'Konum ayarlarını aç'
                              : null,
                      onOpenSettings: provider.homeErrorNeedsAppSettings
                          ? () => _locationService.openAppSettings()
                          : provider.homeErrorNeedsLocationService
                              ? () => _locationService.openLocationSettings()
                              : null,
                    )
                  else if (provider.homeWeather != null)
                    WeatherCard(weather: provider.homeWeather!),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: 'Konumuma Göre Hava Durumunu Getir',
                      icon: Icons.my_location,
                      isLoading: provider.homeIsLoading,
                      onPressed: () => provider.fetchWeatherByGps(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
