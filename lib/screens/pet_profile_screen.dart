import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../providers/pet_provider.dart';
import '../utils/colors.dart';
import '../widgets/pet_mood_widget.dart';
import '../widgets/timeline_card.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/info_card.dart';

class PetProfileScreen extends StatefulWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // In a real app, we would load data for THIS specific pet
      context.read<PetProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final petProvider = context.watch<PetProvider>();
    final activity = petProvider.activity;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.pet.id,
                child: Image.network(
                  widget.pet.imageUrl,
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
                            widget.pet.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.pet.breed,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? AppColors.textSubDark
                                  : AppColors.textSubLight,
                            ),
                          ),
                        ],
                      ),
                      PetMoodWidget(mood: widget.pet.mood),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                          "Age", "${widget.pet.age} years", Icons.cake_rounded),
                      _buildInfoItem("Weight", "${widget.pet.weight} kg",
                          Icons.monitor_weight_rounded),
                      _buildInfoItem("Sex", "Female", Icons.female_rounded),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // DASHBOARD CONTENT MOVED HERE
                  // AI Insights Section
                  Text(
                    "AI INSIGHTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.textSubDark
                          : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...petProvider.insights
                      .map((insight) => AIInsightCard(insight: insight)),

                  const SizedBox(height: 24),

                  // Activity Summary
                  Text(
                    "ACTIVITY SUMMARY",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.textSubDark
                          : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: "STEPS",
                          value: activity?.steps.toString() ?? "0",
                          unit: "steps",
                          icon: Icons.directions_walk_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InfoCard(
                          title: "CALORIES",
                          value: activity?.calories.toInt().toString() ?? "0",
                          unit: "kcal",
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: "ACTIVE",
                          value: activity?.activeMinutes.toString() ?? "0",
                          unit: "min",
                          icon: Icons.timer_rounded,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InfoCard(
                          title: "SLEEP",
                          value: "8.5",
                          unit: "hrs",
                          icon: Icons.nights_stay_rounded,
                          color: Colors.indigo,
                        ),
                      ),
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
                      color: isDark
                          ? AppColors.textSubDark
                          : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (widget.pet.deviceStatus == "Online"
                              ? AppColors.statusHappy
                              : AppColors.textSubLight)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (widget.pet.deviceStatus == "Online"
                                ? AppColors.statusHappy
                                : AppColors.textSubLight)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bluetooth_connected_rounded,
                          color: widget.pet.deviceStatus == "Online"
                              ? AppColors.statusHappy
                              : AppColors.textSubLight,
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
                                  color: isDark
                                      ? AppColors.textMainDark
                                      : AppColors.textMainLight,
                                ),
                              ),
                              Text(
                                widget.pet.deviceStatus == "Online"
                                    ? "Connected • 85% Battery"
                                    : "Disconnected",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textSubDark
                                      : AppColors.textSubLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                            value: widget.pet.deviceStatus == "Online",
                            onChanged: (val) {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions (Moved from old Home too)
                  Text(
                    "QUICK ACTIONS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.textSubDark
                          : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAction(
                        context,
                        Icons.location_on_rounded,
                        "Locate",
                        AppColors.primaryBlue,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.lightbulb_rounded,
                        "Light",
                        Colors.amber,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.volume_up_rounded,
                        "Alert",
                        Colors.purple,
                      ),
                      _buildQuickAction(
                        context,
                        Icons.security_rounded,
                        "Lost Mode",
                        AppColors.errorRed,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Vaccination & History Timeline
                  Text(
                    "PET TIMELINE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.textSubDark
                          : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TimelineCard(
                    title: "Last Vaccination",
                    time: DateFormat('MMM dd, yyyy')
                        .format(widget.pet.lastVaccination),
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
                  const SizedBox(height: 40),
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

  Widget _buildQuickAction(
      BuildContext context, IconData icon, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
          ),
        ),
      ],
    );
  }
}
