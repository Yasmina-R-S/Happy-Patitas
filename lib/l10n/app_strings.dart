
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class AppStrings {
  static final Map<String, Map<String, String>> _localized = {
    'en': {
      'settings': 'Settings',
      'language': 'Language',
      'home': 'Home',
      'heart_rate': 'Heart Rate',
      'body_temperature': 'Body Temperature',
      'sleep_quality': 'Sleep Quality',
      'location': 'Location',
      'support': 'Support',
      'logout': 'Log out',
    },
    'es': {
      'settings': 'Configuración',
      'language': 'Idioma',
      'home': 'Inicio',
      'heart_rate': 'Frecuencia cardíaca',
      'body_temperature': 'Temperatura corporal',
      'sleep_quality': 'Calidad del sueño',
      'location': 'Localización',
      'support': 'Soporte',
      'logout': 'Cerrar sesión',
    },
    'ca': {
      'settings': 'Configuració',
      'language': 'Idioma',
      'home': 'Inici',
      'heart_rate': 'Freqüència cardíaca',
      'body_temperature': 'Temperatura corporal',
      'sleep_quality': 'Qualitat del son',
      'location': 'Localització',
      'support': 'Suport',
      'logout': 'Tancar sessió',
    },
    'bg': {
      'settings': 'Настройки',
      'language': 'Език',
      'home': 'Начало',
      'heart_rate': 'Сърдечен ритъм',
      'body_temperature': 'Телесна температура',
      'sleep_quality': 'Качество на съня',
      'location': 'Локация',
      'support': 'Поддръжка',
      'logout': 'Изход',
    },
  };

  static String t(BuildContext context, String key) {
    final lang = context.watch<LocaleProvider>().locale.languageCode;
    return _localized[lang]?[key] ?? _localized['en']![key] ?? key;
  }
}
