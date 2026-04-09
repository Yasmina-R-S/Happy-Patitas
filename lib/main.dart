import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/icio_creen.dart';
import 'providers/pet_provider.dart';
import 'providers/theme_provider.dart'; // ← añade este import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ← añade este
      ],
      child: MaterialApp(
        title: 'Happy Patitas',
        debugShowCheckedModeBanner: false,
        home: const icioScreen(),
      ),
    );
  }
}