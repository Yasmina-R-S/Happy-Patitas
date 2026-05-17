import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/health_provider.dart';
import '../providers/pet_firebase_provider.dart';
import '../models/pet_model.dart';
import 'pet_profile_screen.dart';
import '../utils/home_navigator_scope.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final healthProvider = context.watch<HealthProvider>();
    final petFirebaseProvider = context.watch<PetFirebaseProvider>();
    final pets = petFirebaseProvider.pets;
    final metrics = healthProvider.getGlobalMetrics(pets);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // HEADER MODERN
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => HomeNavigatorScope.of(context)?.goHome(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Text(
                "Health Overview",
                style: TextStyle(
                  color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SELECTOR DE PERIODO
                  _buildPeriodSelector(healthProvider),
                  const SizedBox(height: 24),

                  // CARDS RESUMEN GLOBALES
                  _buildGlobalMetricsGrid(metrics, isDark),
                  const SizedBox(height: 32),

                  // GRÁFICOS MODERNOS
                  _buildSectionHeader(context, "ACTIVITY TRENDS"),
                  const SizedBox(height: 16),
                  _buildActivityChart(isDark),
                  const SizedBox(height: 32),

                  // SECCIÓN MASCOTAS (Horizontal)
                  _buildSectionHeader(context, "MY PETS"),
                  const SizedBox(height: 16),
                  _buildPetsList(pets, isDark),
                  const SizedBox(height: 32),

                  // INSIGHTS IA
                  _buildSectionHeader(context, "AI HEALTH INSIGHTS"),
                  const SizedBox(height: 16),
                  ...healthProvider.getInsights(pets).map((insight) => _buildInsightCard(insight, isDark)),
                  const SizedBox(height: 32),

                  // TIMELINE INTELIGENTE
                  _buildSectionHeader(context, "RECENT ACTIVITY"),
                  const SizedBox(height: 16),
                  _buildTimeline(healthProvider.getTimeline(pets), isDark),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(HealthProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.ultraLightBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildPeriodButton("Day", HealthPeriod.day, provider),
          _buildPeriodButton("Week", HealthPeriod.week, provider),
          _buildPeriodButton("Month", HealthPeriod.month, provider),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String text, HealthPeriod period, HealthProvider provider) {
    final isSelected = provider.selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setPeriod(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSubLight,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalMetricsGrid(Map<String, dynamic> metrics, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildMetricCard("Steps", metrics['steps'], Icons.directions_walk_rounded, Colors.orange, isDark),
        _buildMetricCard("Calories", metrics['calories'], Icons.local_fire_department_rounded, Colors.red, isDark),
        _buildMetricCard("Active", metrics['activeTime'], Icons.timer_rounded, AppColors.primaryBlue, isDark),
        _buildMetricCard("Sleep", metrics['sleep'], Icons.nightlight_round, Colors.indigo, isDark),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Icon(Icons.trending_up_rounded, color: Colors.green, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(bool isDark) {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  if (value % 1 == 0 && value >= 0 && value < 7) {
                    return Text(
                      days[value.toInt()],
                      style: TextStyle(
                        color: AppColors.textSubLight,
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 4),
                FlSpot(2, 3.5),
                FlSpot(3, 5),
                FlSpot(4, 4.2),
                FlSpot(5, 6),
                FlSpot(6, 5.5),
              ],
              isCurved: true,
              color: AppColors.primaryBlue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primaryBlue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetsList(List<Pet> pets, bool isDark) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PetProfileScreen(pet: pet))),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  FutureBuilder<String?>(
                    future: pet.getFullPhotoPath(),
                    builder: (context, snapshot) {
                      final path = snapshot.data;
                      return Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryBlue, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.ultraLightBlue,
                          backgroundImage: path != null ? (path.startsWith('http') ? NetworkImage(path) as ImageProvider : FileImage(File(path))) : null,
                          child: path == null ? const Icon(Icons.pets, color: AppColors.primaryBlue) : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInsightCard(HealthInsight insight, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(insight.icon, color: insight.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),
                Text(
                  insight.description,
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
    );
  }

  Widget _buildTimeline(List<HealthTimelineItem> items, bool isDark) {
    return Column(
      children: items.map((item) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    item.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  height: 50,
                  color: AppColors.ultraLightBlue,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(item.icon, color: item.color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                            ),
                          ),
                          Text(
                            item.description,
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
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
      ),
    );
  }
}
