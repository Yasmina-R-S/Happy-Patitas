import 'package:flutter/material.dart';
import '../utils/colors.dart';

class BatteryAlertsScreen extends StatefulWidget {
  const BatteryAlertsScreen({super.key});

  @override
  State<BatteryAlertsScreen> createState() => _BatteryAlertsScreenState();
}

class _BatteryAlertsScreenState extends State<BatteryAlertsScreen> {
  bool _enableAlerts = true;
  double _alertThreshold = 20;
  bool _criticalAlert = true;
  bool _dailyBatteryReport = false;
  bool _chargingNotification = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Battery Alerts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(context, "ALERTS"),
          _buildToggleTile(
            context,
            Icons.notifications_active_rounded,
            "Enable Battery Alerts",
            "Get notified about low battery",
            _enableAlerts,
            (val) => setState(() => _enableAlerts = val),
          ),
          _buildToggleTile(
            context,
            Icons.warning_amber_rounded,
            "Critical Battery Alert",
            "Alert at 10% battery or below",
            _criticalAlert,
            (val) => setState(() => _criticalAlert = val),
          ),
          _buildToggleTile(
            context,
            Icons.battery_charging_full_rounded,
            "Charging Notification",
            "Notify when collar starts charging",
            _chargingNotification,
            (val) => setState(() => _chargingNotification = val),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "THRESHOLD"),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.ultraLightBlue,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.battery_alert_rounded,
                          color: AppColors.primaryBlue, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alert Threshold",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textMainDark
                                  : AppColors.textMainLight,
                            ),
                          ),
                          Text(
                            "Alert when battery drops below ${_alertThreshold.toInt()}%",
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
                    Text(
                      "${_alertThreshold.toInt()}%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.primaryBlue,
                    inactiveTrackColor: AppColors.primaryBlue.withOpacity(0.2),
                    thumbColor: AppColors.primaryBlue,
                    overlayColor: AppColors.primaryBlue.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _alertThreshold,
                    min: 5,
                    max: 50,
                    divisions: 9,
                    onChanged: (val) => setState(() => _alertThreshold = val),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("5%",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? AppColors.textSubDark : AppColors.textSubLight,
                        )),
                    Text("50%",
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? AppColors.textSubDark : AppColors.textSubLight,
                        )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "REPORTS"),
          _buildToggleTile(
            context,
            Icons.bar_chart_rounded,
            "Daily Battery Report",
            "Summary of battery usage each day",
            _dailyBatteryReport,
            (val) => setState(() => _dailyBatteryReport = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                    )),
                Text(subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    )),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.primaryBlue),
        ],
      ),
    );
  }
}
