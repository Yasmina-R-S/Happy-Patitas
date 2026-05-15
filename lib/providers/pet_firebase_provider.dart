import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/pet_model.dart';

class PetFirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Pet> _pets = [];
  bool _isLoading = false;

  List<Pet> get pets => List.unmodifiable(_pets);
  bool get isLoading => _isLoading;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ── Carga todas las mascotas del usuario desde Firestore ──────────────────
  Future<void> fetchPets() async {
    if (_uid.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      final snap = await _db
          .collection('mascotas')
          .where('idDueno', isEqualTo: _uid)
          .orderBy('timestamp', descending: false)
          .get();

      _pets = snap.docs
          .map((doc) => Pet.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint('PetFirebaseProvider.fetchPets error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Añade una mascota a Firestore y la agrega localmente ──────────────────
  Future<String> addPet({
    required String nombre,
    required String raza,
    required int edad,
    required double peso,
    String imageUrl = '',
    String deviceStatus = 'Online',
  }) async {
    final docRef = await _db.collection('mascotas').add({
      'idDueno': _uid,
      'nombre': nombre,
      'raza': raza,
      'edad': edad,
      'peso': peso,
      'imageUrl': imageUrl,
      'mood': 'happy',
      'deviceStatus': deviceStatus,
      'lastVaccination':
          DateTime.now().subtract(const Duration(days: 90)).millisecondsSinceEpoch,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final newPet = Pet(
      id: docRef.id,
      name: nombre,
      breed: raza,
      age: edad,
      weight: peso,
      imageUrl: imageUrl,
      mood: PetMood.happy,
      deviceStatus: deviceStatus,
      lastVaccination: DateTime.now().subtract(const Duration(days: 90)),
    );

    _pets.add(newPet);
    notifyListeners();
    return docRef.id;
  }
}
