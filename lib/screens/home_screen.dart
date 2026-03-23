import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';
import '../utils/colors.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/pet_mood_widget.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = context.watch<PetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (petProvider.isLoading && petProvider.currentPet == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final pet = petProvider.currentPet;
    final activity = petProvider.activity;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (pet != null)
                    Image.network(
                      pet.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark ? AppColors.bgDark : AppColors.bgLight).withValues(alpha: 0.8),
                          isDark ? AppColors.bgDark : AppColors.bgLight,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            pet?.name ?? "Loading...",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (pet != null) PetMoodWidget(mood: pet.mood),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // AI Insights Section
                  Text(
                    "AI INSIGHTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...petProvider.insights.map((insight) => AIInsightCard(insight: insight)),

                  const SizedBox(height: 24),

                  // Activity Summary
                  Text(
                    "ACTIVITY SUMMARY",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
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

                  // Quick Actions
                  Text(
                    "QUICK ACTIONS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color) {
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
