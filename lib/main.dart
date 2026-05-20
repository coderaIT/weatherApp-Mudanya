import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/notes_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/search_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Türkçe tarih formatı için locale verilerini yükle
  await initializeDateFormatting('tr_TR', null);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HavaDurumuApp());
}

class HavaDurumuApp extends StatelessWidget {
  const HavaDurumuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF3949AB),
            brightness: Brightness.light,
          ),
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}

/// Alt menü ile 3 ana ekran arasında geçiş.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Sadece aktif sekme build edilir (gereksiz API/DB çağrısı önlenir)
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    NotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          // Notlar sekmesine ilk geçişte notları yükle
          if (index == 2) {
            context.read<NotesProvider>().loadNotes();
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF3949AB).withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Şehir Ara',
          ),
          NavigationDestination(
            icon: Icon(Icons.notes_outlined),
            selectedIcon: Icon(Icons.notes),
            label: 'Notlar',
          ),
        ],
      ),
    );
  }
}
