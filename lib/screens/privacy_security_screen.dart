import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _locationSharing = true;
  bool _dataAnalytics = false;
  bool _twoFactor = false;
  bool _biometric = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy & Security",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(context, "PRIVACY"),
          _buildToggleTile(
            context,
            Icons.location_on_rounded,
            "Location Sharing",
            "Share pet location with trusted contacts",
            _locationSharing,
            (val) => setState(() => _locationSharing = val),
          ),
          _buildToggleTile(
            context,
            Icons.analytics_rounded,
            "Data Analytics",
            "Help improve app with anonymized data",
            _dataAnalytics,
            (val) => setState(() => _dataAnalytics = val),
          ),
          _buildNavTile(
            context,
            Icons.shield_rounded,
            "Safe Zones",
            "Manage allowed locations for your pet",
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "SECURITY"),
          _buildToggleTile(
            context,
            Icons.lock_rounded,
            "Two-Factor Auth",
            "Extra layer of account protection",
            _twoFactor,
            (val) => setState(() => _twoFactor = val),
          ),
          _buildToggleTile(
            context,
            Icons.fingerprint_rounded,
            "Biometric Login",
            "Use fingerprint or face ID to log in",
            _biometric,
            (val) => setState(() => _biometric = val),
          ),
          _buildNavTile(
            context,
            Icons.password_rounded,
            "Change Password",
            "Update your account password",
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "DATA"),
          _buildNavTile(
            context,
            Icons.download_rounded,
            "Export My Data",
            "Download a copy of your data",
          ),
          _buildNavTile(
            context,
            Icons.delete_forever_rounded,
            "Delete Account",
            "Permanently remove your account",
            isDestructive: true,
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

  Widget _buildNavTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDestructive ? AppColors.errorRed : AppColors.primaryBlue;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDestructive
                ? AppColors.errorRed.withOpacity(0.2)
                : isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.ultraLightBlue,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
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
                        color: isDestructive
                            ? AppColors.errorRed
                            : isDark
                                ? AppColors.textMainDark
                                : AppColors.textMainLight,
                      )),
                  Text(subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
