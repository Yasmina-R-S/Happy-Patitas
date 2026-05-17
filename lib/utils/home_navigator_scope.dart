import 'package:flutter/material.dart';

class HomeNavigatorScope extends InheritedWidget {
  final VoidCallback goHome;
  final Function(int) setIndex;

  const HomeNavigatorScope({
    super.key,
    required this.goHome,
    required this.setIndex,
    required super.child,
  });

  static HomeNavigatorScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeNavigatorScope>();
  }

  @override
  bool updateShouldNotify(HomeNavigatorScope oldWidget) {
    return goHome != oldWidget.goHome || setIndex != oldWidget.setIndex;
  }
}
