import '../services/local_picture_service.dart';

enum PetMood { happy, resting, active, stressed }

class Pet {
  final String id;
  final String name;
  final String breed;
  final int age;
  final double weight;
  final String imageUrl; // Puede ser un nombre de archivo local o una URL
  final PetMood mood;
  final String deviceStatus;
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

  /// Resuelve la ruta completa de la imagen (URL o Archivo Local)
  Future<String?> getFullPhotoPath() async {
    if (imageUrl.isEmpty) return null;
    return await LocalPictureService().getFullPath(imageUrl);
  }

  Pet copyWith({
    String? id,
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
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imageUrl: imageUrl ?? this.imageUrl,
      mood: mood ?? this.mood,
      deviceStatus: deviceStatus ?? this.deviceStatus,
      lastVaccination: lastVaccination ?? this.lastVaccination,
    );
  }

  factory Pet.fromMap(String id, Map<String, dynamic> map) {
    PetMood mood;
    switch ((map['mood'] ?? 'happy').toString()) {
      case 'resting':
        mood = PetMood.resting;
        break;
      case 'active':
        mood = PetMood.active;
        break;
      case 'stressed':
        mood = PetMood.stressed;
        break;
      default:
        mood = PetMood.happy;
    }

    DateTime lastVac;
    try {
      final ts = map['lastVaccination'];
      lastVac = ts != null
          ? DateTime.fromMillisecondsSinceEpoch(ts as int)
          : DateTime.now().subtract(const Duration(days: 90));
    } catch (_) {
      lastVac = DateTime.now().subtract(const Duration(days: 90));
    }

    return Pet(
      id: id,
      name: (map['nombre'] ?? map['name'] ?? '').toString(),
      breed: (map['raza'] ?? map['breed'] ?? '').toString(),
      age: ((map['edad'] ?? map['age'] ?? 0) as num).toInt(),
      weight: ((map['peso'] ?? map['weight'] ?? 0.0) as num).toDouble(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      mood: mood,
      deviceStatus: (map['deviceStatus'] ?? 'Offline').toString(),
      lastVaccination: lastVac,
    );
  }

  Map<String, dynamic> toMap() => {
        'nombre': name,
        'raza': breed,
        'edad': age,
        'peso': weight,
        'imageUrl': imageUrl,
        'mood': mood.name,
        'deviceStatus': deviceStatus,
        'lastVaccination': lastVaccination.millisecondsSinceEpoch,
      };
}
