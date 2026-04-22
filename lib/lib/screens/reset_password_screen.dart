import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// LOGO
                Image.asset("assets/logo_hp.png", height: 80),
                const SizedBox(height: 10),
                const Text(
                  "Happy Patitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight,
                  ),
                ),

                const SizedBox(height: 40),

                /// TITULO
                const Text(
                  "CAMBIAR CONTRASEÑA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMainLight,
                  ),
                ),

                const SizedBox(height: 20),

                /// DESCRIPCION 1
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Elige una contraseña segura y única.\nAl cambiarla, se cerrará tu sesión en otros dispositivos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMainLight,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// PRIMER CAMPO (PASSWORD NUEVA)
                _buildGlassBox(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contraseña Nueva",
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
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                /// TEXTO INTERMEDIO
                const Text(
                  "Debe tener al menos 8 caracteres.",
                  style: TextStyle(color: AppColors.textMainLight, fontSize: 13),
                ),

                const SizedBox(height: 15),

                /// SEGUNDO CAMPO (CONFIRMAR)
                _buildGlassBox(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Confirmar la nueva Contraseña",
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Lógica de cambio
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Contraseña cambiada")),
                              );
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: const Text("Cambiar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassBox(BuildContext context, {required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
          child: child,
        ),
      ),
    );
  }
}
