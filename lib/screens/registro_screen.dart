import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/theme_provider.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().themeMode == ThemeMode.dark ||
        (context.watch<ThemeProvider>().themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// LOGO
                Image.asset(
                  "assets/logo_hp.png",
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "Happy Patitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),

                const SizedBox(height: 40),

                /// TITULO
                Text(
                  "REGISTER",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),

                const SizedBox(height: 30),

                /// FORMULARIO CON EFECTO CRISTAL
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.07)
                            : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// NAME
                          Text("Name",
                              style: TextStyle(
                                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                              )),
                          const SizedBox(height: 6),
                          TextField(
                            style: TextStyle(
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// EMAIL
                          Text("Email",
                              style: TextStyle(
                                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                              )),
                          const SizedBox(height: 6),
                          TextField(
                            style: TextStyle(
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          Text("Password",
                              style: TextStyle(
                                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                              )),
                          const SizedBox(height: 6),
                          TextField(
                            obscureText: true,
                            style: TextStyle(
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// CONFIRM PASSWORD
                          Text("Confirm Password",
                              style: TextStyle(
                                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                              )),
                          const SizedBox(height: 6),
                          TextField(
                            obscureText: true,
                            style: TextStyle(
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.surfaceDark.withValues(alpha: 0.8)
                                  : Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// BOTON REGISTER
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // TODO: lógica de registro
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// VOLVER AL LOGIN
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Already have an account? Log in",
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.lightBlue
                                      : AppColors.primaryBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}