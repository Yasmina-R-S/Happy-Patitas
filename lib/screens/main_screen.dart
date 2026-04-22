import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'map_screen.dart';
import 'health_screen.dart';
import 'pets_screen.dart';
import 'settings_screen.dart';
import '../utils/colors.dart';
import '../providers/theme_provider.dart';

/// InheritedWidget que expone el callback goHome() a cualquier widget
/// descendiente, sin necesidad de pasar parámetros por constructor.
class HomeNavigatorScope extends InheritedWidget {
  final VoidCallback goHome;

  const HomeNavigatorScope({
    super.key,
    required this.goHome,
    required super.child,
  });

  static HomeNavigatorScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeNavigatorScope>();
  }

  @override
  bool updateShouldNotify(HomeNavigatorScope oldWidget) =>
      goHome != oldWidget.goHome;
}

/// Wrapper que da a la pestaña Health su propio Navigator anidado.
/// Así el botón atrás en sub-pantallas (HeartRate, BodyTemp, Sleep)
/// vuelve a HealthScreen en lugar de ir al login.
class HealthTab extends StatelessWidget {
  const HealthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HealthScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _goHome() => setState(() => _currentIndex = 0);

  // Usamos HealthTab y SettingsTab (Navigator anidado) para que el botón
  // atrás en sus sub-pantallas vuelva dentro de la pestaña, no al login.
  List<Widget> get _screens => [
    const PetsScreen(),
    const MapScreen(),
    const HealthTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return HomeNavigatorScope(
      goHome: _goHome,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          selectedItemColor: AppColors.primaryBlue,
          unselectedItemColor: AppColors.textSubLight,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: 'Health',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
