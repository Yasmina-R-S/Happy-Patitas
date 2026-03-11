import 'dart:ui';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        /// FONDO DEGRADADO INVERTIDO (AZUL → BLANCO)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF90CAF9),
              Color(0xFFE8F4FD),
              Color(0xFFFFFFFF),
            ],
          ),
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
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// USER
                          const Text("User"),
                          const SizedBox(height: 6),

                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// PASSWORD
                          const Text("Password"),
                          const SizedBox(height: 6),

                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
                                backgroundColor: const Color(0xFF1976D2),
                              ),
                              onPressed: () {},
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
                              onPressed: () {},
                              child: const Text("Forgot password?"),
                            ),
                          ),

                          /// VOLVER
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Volver al inicio"),
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