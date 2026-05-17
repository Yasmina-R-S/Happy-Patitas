import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import 'dart:math';

enum HealthPeriod { day, week, month }

class HealthInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  HealthInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class HealthTimelineItem {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  HealthTimelineItem({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class HealthProvider with ChangeNotifier {
  HealthPeriod _selectedPeriod = HealthPeriod.day;
  final bool _isLoading = false;

  HealthPeriod get selectedPeriod => _selectedPeriod;
  bool get isLoading => _isLoading;

  void setPeriod(HealthPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  // Datos agregados (basados en la cantidad de mascotas)
  Map<String, dynamic> getGlobalMetrics(List<Pet> pets) {
    final int count = pets.isEmpty ? 1 : pets.length;
    final Random random = Random(42); // Seed para consistencia

    // Base values per pet
    int baseSteps = 4500;
    int baseCalories = 300;
    double baseActiveMinutes = 45;
    double baseSleepHours = 8.0;

    switch (_selectedPeriod) {
      case HealthPeriod.day:
        return {
          'steps': '${(baseSteps * count + random.nextInt(1000)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
          'calories': '${(baseCalories * count + random.nextInt(100))}',
          'activeTime': '${(baseActiveMinutes * count / 60).floor()}h ${((baseActiveMinutes * count) % 60).toInt()}m',
          'sleep': '${(baseSleepHours + (random.nextDouble() - 0.5)).toStringAsFixed(1)}h',
          'energy': '${75 + random.nextInt(15)}%',
          'alerts': pets.length > 1 ? 2 : 0,
        };
      case HealthPeriod.week:
        return {
          'steps': '${(baseSteps * 7 * count + random.nextInt(5000)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
          'calories': '${(baseCalories * 7 * count + random.nextInt(500))}',
          'activeTime': '${(baseActiveMinutes * 7 * count / 60).floor()}h ${((baseActiveMinutes * 7 * count) % 60).toInt()}m',
          'sleep': '${(baseSleepHours - 0.2 + (random.nextDouble() - 0.5)).toStringAsFixed(1)}h',
          'energy': '${70 + random.nextInt(15)}%',
          'alerts': pets.length > 1 ? 5 : 1,
        };
      case HealthPeriod.month:
        return {
          'steps': '${(baseSteps * 30 * count + random.nextInt(20000)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},")}',
          'calories': '${(baseCalories * 30 * count + random.nextInt(2000))}',
          'activeTime': '${(baseActiveMinutes * 30 * count / 60).floor()}h ${((baseActiveMinutes * 30 * count) % 60).toInt()}m',
          'sleep': '${(baseSleepHours - 0.1 + (random.nextDouble() - 0.5)).toStringAsFixed(1)}h',
          'energy': '${72 + random.nextInt(15)}%',
          'alerts': pets.length > 1 ? 12 : 3,
        };
    }
  }

  List<HealthInsight> getInsights(List<Pet> pets) {
    if (pets.isEmpty) {
      return [
        HealthInsight(
          title: 'Sin Datos',
          description: 'Agrega una mascota para ver insights de salud.',
          icon: Icons.info_outline,
          color: Colors.grey,
        )
      ];
    }

    final List<HealthInsight> results = [
      HealthInsight(
        title: 'Resumen de Actividad',
        description: 'Tus ${pets.length} mascotas han estado activas hoy.',
        icon: Icons.pets,
        color: Colors.blue,
      ),
    ];

    if (pets.length >= 1) {
      results.add(HealthInsight(
        title: 'Patrón de Sueño',
        description: '${pets[0].name} ha tenido un descanso reparador anoche.',
        icon: Icons.nightlight_round,
        color: Colors.indigo,
      ));
    }

    if (pets.length >= 2) {
      results.add(HealthInsight(
        title: 'Sincronía',
        description: '${pets[0].name} y ${pets[1].name} han compartido sus paseos.',
        icon: Icons.sync,
        color: Colors.green,
      ));
    }

    return results;
  }

  List<HealthTimelineItem> getTimeline(List<Pet> pets) {
    if (pets.isEmpty) return [];

    final String petsNames = pets.length > 2 
        ? '${pets[0].name}, ${pets[1].name} y otros' 
        : pets.map((p) => p.name).join(' y ');

    return [
      HealthTimelineItem(
        time: '14:30',
        title: 'Actividad Grupal',
        description: '$petsNames • Paseo completado',
        icon: Icons.directions_walk_rounded,
        color: Colors.blue,
      ),
      HealthTimelineItem(
        time: '12:00',
        title: 'Alimentación',
        description: 'Todas las mascotas han sido alimentadas',
        icon: Icons.restaurant_rounded,
        color: Colors.orange,
      ),
    ];
  }
}
