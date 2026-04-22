import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/colors.dart';

class SleepQualityScreen extends StatelessWidget {
  const SleepQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sleep Quality',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current value card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3949AB), Color(0xFF9FA8DA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.nightlight_round, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Optimal',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Last night · 8h 20min',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '92 / 100 score',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'SLEEP STAGES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : AppColors.ultraLightBlue,
                ),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 3,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ['10pm', '12am', '2am', '4am', '6am'];
                          if (value.toInt() < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: 9,
                                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                              ),
                            );
                          }
                          return const SizedBox();
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
                    _makeBar(0, 1.5, Colors.indigo.shade300),
                    _makeBar(1, 2.8, Colors.indigo),
                    _makeBar(2, 3.0, Colors.indigo.shade700),
                    _makeBar(3, 2.5, Colors.indigo),
                    _makeBar(4, 1.2, Colors.indigo.shade300),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'THIS WEEK',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              _buildDayRow(context, 'Monday', '7h 45min', 85, isDark),
              _buildDayRow(context, 'Tuesday', '6h 30min', 70, isDark),
              _buildDayRow(context, 'Wednesday', '8h 10min', 90, isDark),
              _buildDayRow(context, 'Thursday', '7h 00min', 78, isDark),
              _buildDayRow(context, 'Friday', '9h 00min', 95, isDark),
              _buildDayRow(context, 'Saturday', '8h 20min', 92, isDark),
            ],
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildDayRow(BuildContext context, String day, String duration, int score, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              day,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.indigo.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  score >= 90 ? Colors.green : score >= 75 ? Colors.indigo : Colors.orange,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            duration,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
            ),
          ),
        ],
      ),
    );
  }
}
