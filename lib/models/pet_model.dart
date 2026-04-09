enum PetMood { happy, resting, active, stressed }

class Pet {
  final String id;
  final String name;
  final String breed;
  final int age;
  final double weight;
  final String imageUrl;
  final PetMood mood;
  final String deviceStatus; // "Online", "Offline"
  final DateTime lastVaccination;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.imageUrl,
    required this.mood,
    required this.deviceStatus,
    required this.lastVaccination,
  });
}
