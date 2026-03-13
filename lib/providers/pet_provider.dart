import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/activity_model.dart';
import '../services/api_service.dart';

class PetProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Pet? _currentPet;
  Activity? _activity;
  List<String> _insights = [];
  bool _isLoading = false;

  Pet? get currentPet => _currentPet;
  Activity? get activity => _activity;
  List<String> get insights => _insights;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentPet = await _apiService.getPetData();
      _activity = await _apiService.getActivityData();
      _insights = await _apiService.getAIInsights();
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
