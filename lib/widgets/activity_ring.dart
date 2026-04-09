import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ActivityRing extends StatelessWidget {
  final double percentage;
  final double size;
  final Color color;
  final IconData? icon;

  const ActivityRing({
    super.key,
    required this.percentage,
    this.size = 120,
    this.color = AppColors.primaryBlue,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: size * 0.1,
            color: color.withOpacity(0.1),
          ),
          CircularProgressIndicator(
            value: percentage,
            strokeWidth: size * 0.1,
            color: color,
            strokeCap: StrokeCap.round,
          ),
          if (icon != null)
            Icon(
              icon,
              color: color,
              size: size * 0.3,
            ),
          if (icon == null)
            Text(
              "${(percentage * 100).toInt()}%",
              style: TextStyle(
                fontSize: size * 0.2,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}
