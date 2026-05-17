import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Devuelve el usuario actualmente autenticado (o null si no hay sesión)
  User? get usuarioActual => _auth.currentUser;

  /// Stream que emite cambios de estado de autenticación
  Stream<User?> get estadoAuth => _auth.authStateChanges();

  /// Registra un nuevo usuario con email y contraseña
  Future<UserCredential> registrarUsuario({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _traducirError(e);
    }
  }

  /// Inicia sesión con email y contraseña
  Future<UserCredential> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _traducirError(e);
    }
  }

  /// Inicia sesión con Google
  Future<UserCredential?> iniciarConGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // El usuario canceló el login

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  /// Envía un correo de recuperación de contraseña
  Future<void> recuperarContrasena(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _traducirError(e);
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> cerrarSesion() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Traduce códigos de error de Firebase a mensajes legibles
  Exception _traducirError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No existe una cuenta con ese correo.');
      case 'wrong-password':
        return Exception('Contraseña incorrecta.');
      case 'email-already-in-use':
        return Exception('Ya existe una cuenta con ese correo.');
      case 'weak-password':
        return Exception('La contraseña debe tener al menos 6 caracteres.');
      case 'invalid-email':
        return Exception('El formato del correo no es válido.');
      case 'too-many-requests':
        return Exception('Demasiados intentos. Inténtalo más tarde.');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }
}
