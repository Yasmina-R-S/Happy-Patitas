import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Devuelve el UID del usuario actual (lanza excepción si no hay sesión)
  String get _uidActual {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No hay sesión activa.');
    return user.uid;
  }

  /// Guarda un collar en Firestore.
  /// Si no se pasa [idDueno], usa automáticamente el UID del usuario autenticado.
  Future<void> guardarCollar({
    String? idDueno,
    required String idMascota,
    required int bateria,
  }) async {
    try {
      await _db.collection('collares').add({
        'idDueno': idDueno ?? _uidActual,
        'idMascota': idMascota,
        'bateria': bateria,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Guarda una mascota en Firestore.
  /// Si no se pasa [idDueno], usa automáticamente el UID del usuario autenticado.
  Future<void> guardarMascota({
    String? idDueno,
    required String nombre,
    required String raza,
    required int edad,
    required double peso,
  }) async {
    try {
      await _db.collection('mascotas').add({
        'idDueno': idDueno ?? _uidActual,
        'nombre': nombre,
        'raza': raza,
        'edad': edad,
        'peso': peso,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
