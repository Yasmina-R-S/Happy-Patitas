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
  final String? ownerId;

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
    this.ownerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'weight': weight,
      'imageUrl': imageUrl,
      'mood': mood.index,
      'deviceStatus': deviceStatus,
      'lastVaccination': lastVaccination.toIso8601String(),
      'ownerId': ownerId,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map, String id) {
    return Pet(
      id: id,
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      mood: PetMood.values[map['mood'] ?? 0],
      deviceStatus: map['deviceStatus'] ?? 'Offline',
      lastVaccination: DateTime.parse(map['lastVaccination'] ?? DateTime.now().toIso8601String()),
      ownerId: map['ownerId'],
    );
  }

  Pet copyWith({
    String? name,
    String? breed,
    int? age,
    double? weight,
    String? imageUrl,
    PetMood? mood,
    String? deviceStatus,
    DateTime? lastVaccination,
  }) {
    return Pet(
      id: id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      mood: mood ?? this.mood,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      lastVaccination: lastVaccination ?? this.lastVaccination,
      ownerId: ownerId,
    );
  }
}
