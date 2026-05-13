import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _prefKey = 'app_locale';

  Locale _locale = const Locale('es');

  Locale get locale => _locale;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ca', 'name': 'Català', 'flag': '🏴'},
    {'code': 'bg', 'name': 'Български', 'flag': '🇧🇬'},
  ];

  /// Carga el idioma guardado (llamar en main antes de runApp)
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }
}
