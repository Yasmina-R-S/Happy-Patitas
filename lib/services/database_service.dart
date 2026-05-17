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

  /// Crea el documento de perfil del usuario en Firestore
  Future<void> crearUsuario({
    required String uid,
    required String name,
    required String email,
    String phone = '',
  }) async {
    try {
      await _db.collection('usuarios').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'hasCompletedProfile': false,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Guarda una mascota en Firestore.
  /// Se usa 'ownerId' para identificar al dueño.
  Future<void> guardarMascota({
    String? ownerId,
    required String nombre,
    required String raza,
    required int edad,
    required double peso,
    String deviceId = '',
  }) async {
    try {
      await _db.collection('mascotas').add({
        'ownerId': ownerId ?? _uidActual,
        'nombre': nombre,
        'raza': raza,
        'edad': edad,
        'peso': peso,
        'deviceId': deviceId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Guarda un collar en Firestore. (Opcional, si se sigue usando por separado)
  Future<void> guardarCollar({
    String? ownerId,
    required String idMascota,
    required int bateria,
  }) async {
    try {
      await _db.collection('collares').add({
        'ownerId': ownerId ?? _uidActual,
        'idMascota': idMascota,
        'bateria': bateria,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
