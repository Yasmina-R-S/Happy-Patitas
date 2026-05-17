import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/local_picture_service.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  /// Resuelve la ruta completa de la imagen (URL o Archivo Local)
  Future<String?> getFullPhotoPath() async {
    if (photoUrl == null) return null;
    return await LocalPictureService().getFullPath(photoUrl);
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
    );
  }
}

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfile(String uid) async {
    debugPrint('UserProvider: Fetching profile for $uid');
    try {
      _isLoading = true;
      notifyListeners();

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();

      if (doc.exists) {
        debugPrint('UserProvider: Profile found');
        _user = UserModel.fromFirestore(doc);
      } else {
        debugPrint('UserProvider: Profile NOT found in Firestore, creating real profile');
        final currentUser = FirebaseAuth.instance.currentUser;
        final newName = currentUser?.displayName ?? 'Usuario Nuevo';
        final newEmail = currentUser?.email ?? 'correo@ejemplo.com';
        final newPhoto = currentUser?.photoURL;

        // Crear en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'name': newName,
          'email': newEmail,
          'photoUrl': newPhoto,
          'createdAt': FieldValue.serverTimestamp(),
          'hasCompletedProfile': false,
        });

        _user = UserModel(
          uid: uid,
          name: newName,
          email: newEmail,
          photoUrl: newPhoto,
        );
      }
    } catch (e) {
      debugPrint('UserProvider: Error loading user: $e');
      // En caso de error, al menos permitimos un perfil mínimo para no bloquear
      _user = UserModel(
        uid: uid,
        name: 'Error User',
        email: 'error@app.com',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    if (_user == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_user!.uid)
          .update({'photoUrl': photoUrl});
      
      _user = _user!.copyWith(photoUrl: photoUrl);
      notifyListeners();
    } catch (e) {
      debugPrint('UserProvider: Error updating photo: $e');
      rethrow;
    }
  }
}
