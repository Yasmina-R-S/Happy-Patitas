import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'forgot_password_screen.dart';
import 'registro_screen.dart';
import '../utils/colors.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _cargando = false;
  bool _googleCargando = false;
  bool _mostrarPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _mostrarError('Por favor, rellena todos los campos.');
      return;
    }
    setState(() => _cargando = true);
    try {
      // Solo iniciamos sesión. El AuthGate detecta el cambio en
      // authStateChanges() y se encarga de cargar el perfil y las mascotas.
      await _authService.iniciarSesion(email: email, password: password);
    } catch (e) {
      if (mounted) _mostrarError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _loginGoogle() async {
    setState(() => _googleCargando = true);
    try {
      // Solo iniciamos sesión. El AuthGate detecta el cambio en
      // authStateChanges() y se encarga de cargar el perfil y las mascotas.
      await _authService.iniciarConGoogle();
    } catch (e) {
      if (mounted) _mostrarError('Error al iniciar con Google: $e');
    } finally {
      if (mounted) setState(() => _googleCargando = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.errorRed,
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
            child: Column(
              children: [
                Column(
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
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 30),
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
                            : Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.12)
                              : AppColors.lightBlue.withOpacity(0.6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email", style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight)),
                          const SizedBox(height: 6),
                          _buildTextField(_emailController, isDark, false, Icons.email_outlined),
                          const SizedBox(height: 20),
                          Text("Password", style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight)),
                          const SizedBox(height: 6),
                          _buildPasswordField(isDark),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _cargando ? null : _entrar,
                              child: _cargando
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text("Log In", style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                side: BorderSide(color: isDark ? AppColors.lightBlue : AppColors.primaryBlue),
                                foregroundColor: isDark ? AppColors.lightBlue : AppColors.primaryBlue,
                              ),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistroScreen())),
                              child: const Text("Register", style: TextStyle(fontSize: 16)),
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
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
                              child: Text("Forgot password?", style: TextStyle(color: isDark ? AppColors.lightBlue : AppColors.primaryBlue)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isDark, bool obscure, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return TextField(
      controller: _passwordController,
      obscureText: !_mostrarPassword,
      style: TextStyle(color: isDark ? AppColors.textMainDark : AppColors.textMainLight),
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark.withOpacity(0.8) : Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.lock_outline, size: 20),
        suffixIcon: IconButton(
          icon: Icon(_mostrarPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
          onPressed: () => setState(() => _mostrarPassword = !_mostrarPassword),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
