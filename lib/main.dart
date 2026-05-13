import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Screens
import 'screens/icio_creen.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';

// Providers
import 'providers/pet_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Cargar idioma guardado
  final localeProvider = LocaleProvider();
  await localeProvider.loadSavedLocale();

  runApp(MyApp(localeProvider: localeProvider));
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;

  const MyApp({
    super.key,
    required this.localeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Happy Patitas',

            // Localización
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('ca'),
              Locale('bg'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Tema
            themeMode: themeProvider.themeMode,

            theme: ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xFF1976D2),
              useMaterial3: true,
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: const Color(0xFF1976D2),
              useMaterial3: true,
            ),

            // Inicio app
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

/// Escucha autenticación y redirige según estado
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashCargando();
        }

        // Usuario logueado
        if (snapshot.hasData) {
          return const MainScreen();
        }

        // Usuario no logueado
        return const LoginScreen();
      },
    );
  }
}

class SplashCargando extends StatelessWidget {
  const SplashCargando({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}