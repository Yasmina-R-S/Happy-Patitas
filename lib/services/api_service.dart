import '../models/pet_model.dart';
import '../models/activity_model.dart';

class ApiService {
  // Mock data for the smart pet ecosystem

  Future<Pet> getPetData() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return Pet(
      id: "1",
      name: "Luna",
      breed: "Golden Retriever",
      age: 3,
      weight: 28.5,
      imageUrl: "https://images.unsplash.com/photo-1543466835-00a7907e9de1?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
      mood: PetMood.happy,
      deviceStatus: "Online",
      lastVaccination: DateTime.now().subtract(const Duration(days: 60)),
    );
  }

  Future<Activity> getActivityData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Activity(
      steps: 8432,
      calories: 450,
      activeMinutes: 120,
      goalPercentage: 0.85,
    );
  }

  Future<List<String>> getAIInsights() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      "Luna is very active today. She has reached 85% of her daily step goal.",
      "Consider a longer walk in the evening to meet the activity target.",
      "Sleep quality last night was optimal: 9 hours of resting time.",
    ];
  }
}
