import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ca', 'name': 'Català', 'flag': '🏴'},
    {'code': 'bg', 'name': 'Български', 'flag': '🇧🇬'},
  ];

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
