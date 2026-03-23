import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registro_screen.dart';
import '../utils/colors.dart';

class icioScreen extends StatelessWidget {
  const icioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// LOGO
              Image.asset(
                "assets/logo_hp.png",
                height: 135,
              ),
              const SizedBox(height: 10),
              const Text(
                "Happy Patitas",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMainLight,
                ),
              ),

              const SizedBox(height: 40),

              /// BOTON LOGIN
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// BOTON REGISTRO
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryBlue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegistroScreen()),
                    );
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}