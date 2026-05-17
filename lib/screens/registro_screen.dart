import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../providers/pet_firebase_provider.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _googleCargando = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      _mostrarSnackBar("Please fill all required fields", isError: true);
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _mostrarSnackBar("Passwords do not match", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Crear usuario en FirebaseAuth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      // 2. Crear documento en Firestore usuarios/{uid}
      await DatabaseService().crearUsuario(
        uid: uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        // Al registrarse, el AuthGate de main.dart detectará el cambio y redirigirá a MainScreen
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _mostrarSnackBar(e.message ?? "Registration error", isError: true);
    } catch (e) {
      if (mounted) _mostrarSnackBar("Error: $e", isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginGoogle() async {
    setState(() => _googleCargando = true);
    try {
      final userCredential = await _authService.iniciarConGoogle();
      if (userCredential != null && userCredential.user != null && mounted) {
        await context.read<UserProvider>().fetchUserProfile(userCredential.user!.uid);
        if (mounted) {
          await context.read<PetFirebaseProvider>().fetchPets();
        }
      }
    } catch (e) {
      if (mounted) _mostrarSnackBar('Error al iniciar con Google: $e', isError: true);
    } finally {
      if (mounted) setState(() => _googleCargando = false);
    }
  }

  void _mostrarSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorRed : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Image.asset("assets/logo_hp.png", height: 80),
                const SizedBox(height: 10),
                Text(
                  "Happy Patitas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "REGISTER",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.07)
                            : Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("Name", isDark),
                          _buildTextField(_nameController, isDark, false),
                          const SizedBox(height: 15),
                          _buildLabel("Email", isDark),
                          _buildTextField(_emailController, isDark, false),
                          const SizedBox(height: 15),
                          _buildLabel("Phone (Optional)", isDark),
                          _buildTextField(_phoneController, isDark, false),
                          const SizedBox(height: 15),
                          _buildLabel("Password", isDark),
                          _buildTextField(_passwordController, isDark, true),
                          const SizedBox(height: 15),
                          _buildLabel("Confirm Password", isDark),
                          _buildTextField(_confirmPasswordController, isDark, true),
                          const SizedBox(height: 25),
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
                              onPressed: _isLoading ? null : _register,
                              child: _isLoading 
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text("Register", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                                foregroundColor: isDark ? Colors.white : Colors.black87,
                                elevation: 0,
                                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              onPressed: _googleCargando ? null : _loginGoogle,
                              icon: _googleCargando 
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                : const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 18),
                              label: const Text("Continue with Google", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Already have an account? Log in",
                                style: TextStyle(color: isDark ? AppColors.lightBlue : AppColors.primaryBlue),
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

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight)),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isDark, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
