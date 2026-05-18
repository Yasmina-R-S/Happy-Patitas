import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

import 'providers/pet_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/pet_firebase_provider.dart';
import 'providers/user_provider.dart';
import 'providers/health_provider.dart';
import 'providers/navigation_provider.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/ai_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => PetFirebaseProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Happy Patitas',

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

            routes: {
              '/ai-chat': (context) => AIChatScreen(),
            },

            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _lastUid;

  void _onUserLoggedIn(String uid) {
    context.read<UserProvider>().fetchUserProfile(uid);

    context.read<PetFirebaseProvider>().fetchPets(
      uid: uid,
    );
  }

  void _onUserLoggedOut() {
    context.read<UserProvider>().clearUser();

    context.read<PetFirebaseProvider>().clearPets();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashCargando();
        }

        final user = snapshot.data;

        if (user != null) {
          if (_lastUid != user.uid) {
            _lastUid = user.uid;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                debugPrint(
                  "AuthGate: login detectado uid=${user.uid}",
                );

                _onUserLoggedIn(user.uid);
              }
            });
          }

          return Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              if (userProvider.isLoading ||
                  userProvider.user == null) {
                return const _SplashCargando();
              }

              return const MainScreen();
            },
          );
        }

        if (_lastUid != null) {
          _lastUid = null;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _onUserLoggedOut();
            }
          });
        }

        return const LoginScreen();
      },
    );
  }
}

class _SplashCargando extends StatelessWidget {
  const _SplashCargando();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}