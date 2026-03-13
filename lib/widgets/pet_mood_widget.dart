import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../utils/colors.dart';

class PetMoodWidget extends StatelessWidget {
  final PetMood mood;

  const PetMoodWidget({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (mood) {
      case PetMood.happy:
        color = AppColors.statusHappy;
        label = "Happy";
        icon = Icons.sentiment_very_satisfied_rounded;
        break;
      case PetMood.resting:
        color = AppColors.statusResting;
        label = "Resting";
        icon = Icons.king_bed_rounded;
        break;
      case PetMood.active:
        color = AppColors.statusActive;
        label = "Active";
        icon = Icons.bolt_rounded;
        break;
      case PetMood.stressed:
        color = AppColors.errorRed;
        label = "Stressed";
        icon = Icons.warning_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
