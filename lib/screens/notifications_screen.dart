import 'package:flutter/material.dart';
import '../utils/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _activityAlerts = true;
  bool _healthAlerts = true;
  bool _locationAlerts = false;
  bool _feedingReminders = true;
  bool _sleepReports = false;
  bool _weeklyDigest = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(context, "PET ALERTS"),
          _buildToggleTile(
            context,
            Icons.directions_run_rounded,
            "Activity Alerts",
            "Get notified of unusual activity",
            _activityAlerts,
            (val) => setState(() => _activityAlerts = val),
          ),
          _buildToggleTile(
            context,
            Icons.favorite_rounded,
            "Health Alerts",
            "Heart rate & temperature warnings",
            _healthAlerts,
            (val) => setState(() => _healthAlerts = val),
          ),
          _buildToggleTile(
            context,
            Icons.location_on_rounded,
            "Location Alerts",
            "Safe zone entry & exit",
            _locationAlerts,
            (val) => setState(() => _locationAlerts = val),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "REMINDERS"),
          _buildToggleTile(
            context,
            Icons.restaurant_rounded,
            "Feeding Reminders",
            "Daily meal time notifications",
            _feedingReminders,
            (val) => setState(() => _feedingReminders = val),
          ),
          _buildToggleTile(
            context,
            Icons.bedtime_rounded,
            "Sleep Reports",
            "Morning sleep quality summary",
            _sleepReports,
            (val) => setState(() => _sleepReports = val),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "REPORTS"),
          _buildToggleTile(
            context,
            Icons.summarize_rounded,
            "Weekly Digest",
            "Weekly health & activity summary",
            _weeklyDigest,
            (val) => setState(() => _weeklyDigest = val),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
