import 'package:flutter/material.dart';
import '../utils/colors.dart';

class AIInsightCard extends StatelessWidget {
  final String insight;

  const AIInsightCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              insight,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
