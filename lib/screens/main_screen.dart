// lib/screens/main_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
//  Happy Patitas · Main Screen — Floating Morphic Nav Bar
//  Índices (array _screens):
//    0 → PetsScreen   (Inicio)
//    1 → MapScreen    (Mapa)
//    2 → AIChatScreen (IA)
//    3 → HealthTab    (Salud)
//    4 → SettingsTab  (Ajustes)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'map_screen.dart';
import 'health_screen.dart';
import 'pets_screen.dart';
import 'settings_screen.dart';
import 'ai_chat_screen.dart';

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

// ─── Tokens de diseño ────────────────────────────────────────────────────────

class _T {
  // Coral vibrante + verde neón como acentos
  static const coral    = Color(0xFFFF6B6B);
  static const lime     = Color(0xFFC8F135);
  static const teal     = Color(0xFF00D4AA);
  static const navDark  = Color(0xFF0E0E16);
  static const navLight = Color(0xFFFFFFFF);
}

// ─── Datos de cada ítem ───────────────────────────────────────────────────────

class _Item {
  final int    index;
  final IconData icon;
  final IconData iconFilled;
  final String labelKey;
  final String? labelFixed;
  final Color  accent;

  const _Item({
    required this.index,
    required this.icon,
    required this.iconFilled,
    required this.labelKey,
    this.labelFixed,
    required this.accent,
  });
}

const _items = [
  _Item(index: 0, icon: Icons.home_outlined,         iconFilled: Icons.home_rounded,          labelKey: 'home',   accent: Color(0xFFFF6B6B)),
  _Item(index: 1, icon: Icons.map_outlined,           iconFilled: Icons.map_rounded,           labelKey: 'map',    accent: Color(0xFF00D4AA)),
  _Item(index: 2, icon: Icons.hub_outlined,           iconFilled: Icons.hub_rounded,           labelKey: '',  labelFixed: 'IA',     accent: Color(0xFFC8F135)),
  _Item(index: 3, icon: Icons.favorite_outline,       iconFilled: Icons.favorite_rounded,      labelKey: 'health', accent: Color(0xFFFF6B6B)),
  _Item(index: 4, icon: Icons.settings_outlined,      iconFilled: Icons.settings_rounded,      labelKey: 'settings', accent: Color(0xFF00D4AA)),
];

// ─── MainScreen ──────────────────────────────────────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {

  // Una AnimationController por ítem para el efecto "press"
  late final List<AnimationController> _itemCtrl = List.generate(
    5,
    (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 280)),
  );

  // Indicador deslizante
  late final AnimationController _slideCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late Animation<double> _slideAnim;
  int _prevIndex = 0;

  List<Widget> get _screens => [
    const PetsScreen(),   // 0 — Inicio
    const MapScreen(),    // 1 — Mapa
    AIChatScreen(),       // 2 — IA
    const HealthTab(),    // 3 — Salud
    const SettingsTab(),  // 4 — Ajustes
  ];

  @override
  void initState() {
    super.initState();
    _slideAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic),
    );
    // Activa el primer ítem
    _itemCtrl[0].forward();
  }

  void _onTabTap(int newIndex, NavigationProvider nav) {
    final prev = nav.currentIndex;
    if (newIndex == prev) return;

    // Animación de "bounce" en el ítem pulsado
    _itemCtrl[newIndex]
      ..reset()
      ..forward();

    // Deslizador suave
    _slideAnim = Tween<double>(
      begin: prev.toDouble(),
      end:   newIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl
      ..reset()
      ..forward();

    _prevIndex = prev;
    nav.setIndex(newIndex);
  }

  @override
  void dispose() {
    for (final c in _itemCtrl) c.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navProvider = context.watch<NavigationProvider>();
    final current = navProvider.currentIndex;

    return HomeNavigatorScope(
      goHome: () => navProvider.goHome(),
      setIndex: (i) => _onTabTap(i, navProvider),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && current != 0) _onTabTap(0, navProvider);
        },
        child: Scaffold(
          backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
          body: Stack(
            children: [
              // Pantallas
              IndexedStack(index: current, children: _screens),

              // Nav bar flotante en la parte inferior
              Positioned(
                left: 16, right: 16, bottom: 16,
                child: _FloatingNavBar(
                  isDark: isDark,
                  currentIndex: current,
                  slideAnim: _slideAnim,
                  itemCtrl: _itemCtrl,
                  onTap: (i) => _onTabTap(i, navProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Floating Nav Bar ─────────────────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final bool isDark;
  final int currentIndex;
  final Animation<double> slideAnim;
  final List<AnimationController> itemCtrl;
  final void Function(int) onTap;

  const _FloatingNavBar({
    required this.isDark,
    required this.currentIndex,
    required this.slideAnim,
    required this.itemCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _items[currentIndex].accent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.85),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.9),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.18),
                blurRadius: 32,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.5 : 0.10),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: _items.map((item) {
              return _NavButton(
                item: item,
                isDark: isDark,
                isActive: currentIndex == item.index,
                ctrl: itemCtrl[item.index],
                onTap: () => onTap(item.index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Un botón de nav ──────────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final _Item item;
  final bool isDark;
  final bool isActive;
  final AnimationController ctrl;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isDark,
    required this.isActive,
    required this.ctrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = item.labelFixed ?? T.of(context, item.labelKey);
    final color = isActive ? item.accent : (isDark ? Colors.white38 : Colors.black38);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (_, __) {
            final bounce = Curves.elasticOut.transform(ctrl.value);
            final scale  = isActive ? (0.8 + 0.2 * bounce) : 1.0;
            return Transform.scale(
              scale: scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícono con halo cuando activo
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: isActive ? 46 : 34,
                    height: isActive ? 34 : 28,
                    decoration: isActive
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: item.accent.withOpacity(0.18),
                            boxShadow: [
                              BoxShadow(
                                color: item.accent.withOpacity(0.35),
                                blurRadius: 12,
                                spreadRadius: -2,
                              ),
                            ],
                          )
                        : null,
                    child: Icon(
                      isActive ? item.iconFilled : item.icon,
                      size: isActive ? 22 : 20,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: color,
                      fontSize: isActive ? 11 : 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      letterSpacing: isActive ? 0.2 : 0.1,
                    ),
                    child: Text(label),
                  ),
                  // Punto indicador activo
                  const SizedBox(height: 1),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 16 : 0,
                    height: isActive ? 3 : 0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: item.accent,
                      boxShadow: isActive
                          ? [BoxShadow(color: item.accent.withOpacity(0.6), blurRadius: 6)]
                          : null,
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
