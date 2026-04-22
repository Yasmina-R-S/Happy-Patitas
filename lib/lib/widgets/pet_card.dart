import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../utils/colors.dart';
import 'pet_mood_widget.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback onTap;

  const PetCard({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
          ),
        ),
        child: Row(
          children: [
            Hero(
              tag: pet.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  pet.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    child: const Icon(Icons.pets, color: AppColors.primaryBlue),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: AppColors.ultraLightBlue,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: pet.deviceStatus == "Online"
                              ? AppColors.statusHappy.withOpacity(0.1)
                              : AppColors.textSubLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          pet.deviceStatus,
                          style: TextStyle(
                            fontSize: 10,
                            color: pet.deviceStatus == "Online"
                                ? AppColors.statusHappy
                                : AppColors.textSubLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${pet.breed} • ${pet.age} years",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PetMoodWidget(mood: pet.mood),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSubLight),
          ],
        ),
      ),
    );
  }
}
