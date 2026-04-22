import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/colors.dart';

class HeartRateScreen extends StatelessWidget {
  const HeartRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Heart Rate',
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
                  colors: [Color(0xFFE53935), Color(0xFFEF9A9A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    '84',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'bpm',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Normal',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'TODAY\'S TREND',
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
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : AppColors.ultraLightBlue,
                ),
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const hours = ['6am', '9am', '12pm', '3pm', '6pm', '9pm'];
                          if (value.toInt() < hours.length) {
                            return Text(
                              hours[value.toInt()],
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 72),
                        FlSpot(1, 78),
                        FlSpot(2, 84),
                        FlSpot(3, 90),
                        FlSpot(4, 84),
                        FlSpot(5, 76),
                      ],
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.red.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'STATS',
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
                Expanded(child: _buildStatCard(context, 'Min', '62 bpm', Colors.green, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Avg', '78 bpm', Colors.orange, isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, 'Max', '112 bpm', Colors.red, isDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
