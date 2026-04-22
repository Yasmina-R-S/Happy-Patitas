import 'dart:ui';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'forgot_password_screen.dart';
import '../utils/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        /// FONDO DEGRADADO INVERTIDO (AZUL → BLANCO)
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                /// LOGO
                Column(
                  children: [
                    Image.asset(
                      "assets/logo_hp.png", // ← Aquí está tu logo
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Happy Patitas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMainLight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// TITULO
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight,
                  ),
                ),

                const SizedBox(height: 30),

                /// FORMULARIO CON EFECTO CRISTAL
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12,
                      sigmaY: 12,
                    ),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// USER
                          const Text(
                            "User",
                            style: TextStyle(color: AppColors.textMainLight),
                          ),
                          const SizedBox(height: 6),

                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          const Text(
                            "Password",
                            style: TextStyle(color: AppColors.textMainLight),
                          ),
                          const SizedBox(height: 6),

                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// BOTON LOGIN
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainScreen()),
                                );
                              },
                              child: const Text(
                                "Log in",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// FORGOT PASSWORD
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen()),
                                );
                              },
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(color: AppColors.primaryBlue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
