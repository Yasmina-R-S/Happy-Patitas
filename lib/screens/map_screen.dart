import 'package:flutter/material.dart';
import '../utils/colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Placeholder for Google Maps
          Container(
            width: double.infinity,
            height: double.infinity,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 100,
                    color: (isDark ? AppColors.textSubDark : AppColors.textSubLight).withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Google Maps View",
                    style: TextStyle(
                      color: (isDark ? AppColors.textSubDark : AppColors.textSubLight).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Safe Zone Visualization (Circle Overlay Placeholder)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),

          // Glowing Marker Placeholder
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                    ),
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Top Info Card
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.statusHappy.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.statusHappy),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home • Safe Zone",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                          ),
                        ),
                        Text(
                          "At the park • 2 minutes ago",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: AppColors.surfaceLight,
                      child: const Icon(Icons.my_location_rounded, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("LOST PET MODE", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.radar_rounded, color: AppColors.primaryBlue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
