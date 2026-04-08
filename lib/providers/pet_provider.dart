import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet_model.dart';
import '../models/activity_model.dart';
import '../services/firestore_service.dart';
import '../services/api_service.dart';

class PetProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final ApiService _apiService = ApiService();
  
  List<Pet> _pets = [];
  Pet? _currentPet;
  Activity? _activity;
  List<String> _insights = [];
  bool _isLoading = false;
  StreamSubscription? _petsSubscription;

  List<Pet> get pets => _pets;
  Pet? get currentPet => _currentPet;
  Activity? get activity => _activity;
  List<String> get insights => _insights;
  bool get isLoading => _isLoading;

  PetProvider() {
    _initPetsListener();
  }

  void _initPetsListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _petsSubscription?.cancel();
      _petsSubscription = _firestoreService.getPets(user.uid).listen((pets) {
        _pets = pets;
        if (_currentPet == null && pets.isNotEmpty) {
          _currentPet = pets.first;
          loadDashboardData();
        }
        notifyListeners();
      });
    }
  }

  void setCurrentPet(Pet pet) {
    _currentPet = pet;
    loadDashboardData();
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    if (_currentPet == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      // For now we keep some mock data from ApiService for activity/insights
      _activity = await _apiService.getActivityData();
      _insights = await _apiService.getAIInsights();
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPet(String name, String breed, int age, double weight, String imageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final newPet = Pet(
      id: '',
      name: name,
      breed: breed,
      age: age,
      weight: weight,
      imageUrl: imageUrl,
      mood: PetMood.happy,
      deviceStatus: 'Online',
      lastVaccination: DateTime.now(),
      ownerId: user.uid,
    );

    await _firestoreService.addPet(newPet);
  }

  Future<void> updatePet(Pet pet) async {
    await _firestoreService.updatePet(pet);
  }

  Future<void> deletePet(String petId) async {
    await _firestoreService.deletePet(petId);
    if (_currentPet?.id == petId) {
      _currentPet = _pets.isNotEmpty ? _pets.first : null;
      loadDashboardData();
    }
  }

  @override
  void dispose() {
    _petsSubscription?.cancel();
    super.dispose();
  }
}
