import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'providers/pet_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/colors.dart';

void main() async {
  // Asegura que los plugins nativos se inicialicen antes de correr la app
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer seguro para ThemeProvider
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Happy Patitas',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryBlue,
              primary: AppColors.primaryBlue,
              surface: AppColors.surfaceLight,
            ),
            textTheme: GoogleFonts.interTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: AppColors.bgLight,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.textMainLight),
            ),
            cardTheme: CardThemeData( // ✅ Cambiado
              color: AppColors.surfaceLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(
                  color: AppColors.ultraLightBlue,
                  width: 1,
                ),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryBlue,
              brightness: Brightness.dark,
              primary: AppColors.primaryBlue,
              surface: AppColors.surfaceDark,
            ),
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.dark().textTheme,
            ),
            scaffoldBackgroundColor: AppColors.bgDark,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.textMainDark),
            ),
            cardTheme: CardThemeData( // ✅ Cambiado
              color: AppColors.surfaceDark,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: AppColors.primaryBlue.withOpacity(0.05), // ✅ usa un color definido
                  width: 1,
                ),
              ),
            ),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}