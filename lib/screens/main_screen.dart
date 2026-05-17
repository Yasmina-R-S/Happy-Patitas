import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'map_screen.dart';
import 'health_screen.dart';
import 'pets_screen.dart';
import 'settings_screen.dart';
import '../utils/colors.dart';
import '../utils/translations.dart';
import '../utils/home_navigator_scope.dart';
import '../providers/navigation_provider.dart';

/// Wrapper que da a la pestaña Health su propio Navigator anidado.
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
    final navProvider = context.watch<NavigationProvider>();

    return HomeNavigatorScope(
      goHome: () => navProvider.goHome(),
      setIndex: (index) => navProvider.setIndex(index),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (navProvider.currentIndex != 0) {
            navProvider.goHome();
          }
        },
        child: Scaffold(
          body: IndexedStack(
            index: navProvider.currentIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navProvider.currentIndex,
            onTap: (index) => navProvider.setIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.textSubLight,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.pets_rounded),
                label: T.of(context, 'home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.map_rounded),
                label: T.of(context, 'map'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite_rounded),
                label: T.of(context, 'health'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_rounded),
                label: T.of(context, 'settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
