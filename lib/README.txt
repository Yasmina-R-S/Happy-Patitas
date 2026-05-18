INSTRUCCIONES

1. Copia estas carpetas dentro de tu /lib
2. Agrega en pubspec.yaml:

dependencies:
  http: ^1.2.1

3. Ejecuta:
flutter pub get

4. Pon tu API KEY de Groq en:
lib/services/ai_service.dart

5. Importa AIChatScreen en tu navegación.

6. Agrega:
const AIChatScreen(),

en tu lista de pantallas.
