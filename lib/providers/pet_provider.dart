import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetActivity {
  final int steps;
  final int calories;
  final int activeMinutes;

  PetActivity({
    required this.steps,
    required this.calories,
    required this.activeMinutes,
  });
}

class PetInsight {
  final String insight;

  PetInsight({
    required this.insight,
  });
}

class PetProvider with ChangeNotifier {
  bool _isLoading = false;

  Pet? _currentPet;

  PetActivity? _activity;

  final List<PetInsight> _insights = [
    PetInsight(insight: 'Tu mascota está muy activa hoy'),
    PetInsight(insight: 'Buen nivel de actividad'),
  ];

  bool get isLoading => _isLoading;

  Pet? get currentPet => _currentPet;

  PetActivity? get activity => _activity;

  List<PetInsight> get insights => _insights;

  void setCurrentPet(Pet pet) {
    _currentPet = pet;
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    debugPrint('PetProvider: Loading dashboard data...');
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _currentPet ??= Pet(
        id: 'demo_1',
        name: 'Luna (Demo)',
        breed: 'Golden Retriever',
        age: 3,
        weight: 24.5,
        imageUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a',
        mood: PetMood.happy,
        deviceStatus: 'Online',
        lastVaccination: DateTime.now(),
      );

      _activity = PetActivity(
        steps: 3421,
        calories: 245,
        activeMinutes: 87,
      );
      debugPrint('PetProvider: Dashboard data loaded successfully');
    } catch (e) {
      debugPrint('PetProvider: Error loading dashboard: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint('PetProvider: Loading finished, isLoading = $_isLoading');
    }
  }

  Future<void> updatePetPhoto(String petId, String imageUrl) async {
    try {
      if (petId != 'demo_1') {
        await FirebaseFirestore.instance
            .collection('mascotas')
            .doc(petId)
            .update({'imageUrl': imageUrl});
      } else {
        debugPrint('PetProvider: Updating demo pet photo only locally');
      }

      if (_currentPet?.id == petId) {
        _currentPet = _currentPet!.copyWith(imageUrl: imageUrl);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('PetProvider: Error updating pet photo: $e');
      rethrow;
    }
  }
}
