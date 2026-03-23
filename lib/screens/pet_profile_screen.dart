import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pet_model.dart';
import '../utils/colors.dart';
import '../widgets/pet_mood_widget.dart';
import '../widgets/timeline_card.dart';

class PetProfileScreen extends StatelessWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: pet.id,
                child: Image.network(
                  pet.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            pet.breed,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                            ),
                          ),
                        ],
                      ),
                      PetMoodWidget(mood: pet.mood),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem("Age", "${pet.age} years", Icons.cake_rounded),
                      _buildInfoItem("Weight", "${pet.weight} kg", Icons.monitor_weight_rounded),
                      _buildInfoItem("Sex", "Female", Icons.female_rounded),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Device Status Section
                  Text(
                    "DEVICE STATUS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bluetooth_connected_rounded,
                          color: pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Smart Collar v2",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                                ),
                              ),
                              Text(
                                pet.deviceStatus == "Online" ? "Connected • 85% Battery" : "Disconnected",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(value: pet.deviceStatus == "Online", onChanged: (val) {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Vaccination & History Timeline
                  Text(
                    "PET TIMELINE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TimelineCard(
                    title: "Last Vaccination",
                    time: DateFormat('MMM dd, yyyy').format(pet.lastVaccination),
                    icon: Icons.vaccines_rounded,
                  ),
                  const TimelineCard(
                    title: "Vet Checkup",
                    time: "Oct 12, 2025",
                    icon: Icons.local_hospital_rounded,
                  ),
                  const TimelineCard(
                    title: "Grooming Session",
                    time: "Sep 28, 2025",
                    icon: Icons.content_cut_rounded,
                    isLast: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSubLight),
        ),
      ],
    );
  }
}
