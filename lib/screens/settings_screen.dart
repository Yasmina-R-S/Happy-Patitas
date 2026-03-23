import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // User Profile Section
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                  ),
                ),
                const Text(
                  "Premium Member",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Settings Groups
          _buildSectionHeader(context, "APP SETTINGS"),
          _buildSettingsTile(
            context,
            Icons.notifications_rounded,
            "Notifications",
            "Manage alerts & sounds",
            true,
          ),
          _buildSettingsTile(
            context,
            Icons.security_rounded,
            "Privacy & Security",
            "Safe zones, data sharing",
            false,
          ),
          _buildSettingsTile(
            context,
            Icons.dark_mode_rounded,
            "Dark Mode",
            "Switch app appearance",
            true,
            onActionTap: () => themeProvider.toggleTheme(),
            actionWidget: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
            ),
          ),

          const SizedBox(height: 32),
          _buildSectionHeader(context, "DEVICE SETTINGS"),
          _buildSettingsTile(
            context,
            Icons.bluetooth_rounded,
            "Collar Management",
            "Connected devices",
            false,
          ),
          _buildSettingsTile(
            context,
            Icons.battery_charging_full_rounded,
            "Battery Alerts",
            "Low power notifications",
            true,
          ),

          const SizedBox(height: 32),
          _buildSectionHeader(context, "ACCOUNT"),
          _buildSettingsTile(
            context,
            Icons.help_outline_rounded,
            "Support",
            "FAQ, contact us",
            false,
          ),
          const SizedBox(height: 16),

          // Logout Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed.withValues(alpha: 0.1),
              foregroundColor: AppColors.errorRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.errorRed.withValues(alpha: 0.3)),
              ),
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text(
              "Log Out",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
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

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool hasAction, {
    VoidCallback? onActionTap,
    Widget? actionWidget,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onActionTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
            if (actionWidget != null)
              actionWidget
            else if (hasAction)
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSubLight)
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSubLight),
          ],
        ),
      ),
    );
  }
}
