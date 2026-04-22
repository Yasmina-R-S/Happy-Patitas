import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/colors.dart';
import '../widgets/activity_ring.dart';
import 'heart_rate_screen.dart';
import 'body_temp_screen.dart';
import 'sleep_quality_screen.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health & Activity",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Goal Rings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRingWithLabel("Activity", 0.85, AppColors.primaryBlue, Icons.bolt_rounded),
                _buildRingWithLabel("Exercise", 0.60, AppColors.statusHappy, Icons.directions_run_rounded),
                _buildRingWithLabel("Stand", 0.90, Colors.orange, Icons.accessibility_new_rounded),
              ],
            ),
            const SizedBox(height: 32),

            // Weekly Activity Graph
            Text(
              "WEEKLY ACTIVITY",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.ultraLightBlue,
                ),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(
                              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeGroupData(0, 45, AppColors.primaryBlue),
                    _makeGroupData(1, 70, AppColors.primaryBlue),
                    _makeGroupData(2, 30, AppColors.primaryBlue),
                    _makeGroupData(3, 90, AppColors.primaryBlue),
                    _makeGroupData(4, 50, AppColors.primaryBlue),
                    _makeGroupData(5, 80, AppColors.primaryBlue),
                    _makeGroupData(6, 65, AppColors.primaryBlue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Health Metrics
            Text(
              "HEALTH METRICS",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricTile(
              context,
              Icons.favorite_rounded,
              "Heart Rate",
              "84 bpm",
              Colors.red,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HeartRateScreen())),
            ),
            _buildMetricTile(
              context,
              Icons.thermostat_rounded,
              "Body Temp",
              "38.2 °C",
              Colors.orange,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyTempScreen())),
            ),
            _buildMetricTile(
              context,
              Icons.nightlight_round,
              "Sleep Quality",
              "Optimal",
              Colors.indigo,
              () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SleepQualityScreen())),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRingWithLabel(String label, double percentage, Color color, IconData icon) {
    return Column(
      children: [
        ActivityRing(percentage: percentage, size: 80, color: color, icon: icon),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: color.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
