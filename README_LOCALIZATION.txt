PASOS IMPORTANTES:

1. Copia esta carpeta lib dentro de tu proyecto.
2. Añade en pubspec.yaml:

flutter:
  generate: true

dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2

3. Ejecuta:
flutter pub get

4. Reemplaza TODOS los textos hardcodeados:

ANTES:
Text('Configuración')

DESPUÉS:
Text(AppLocalizations.of(context)!.settings)

