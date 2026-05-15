import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/translations.dart';

import 'login_screen.dart';
import 'notifications_screen.dart';
import 'privacy_security_screen.dart';
import 'collar_management_screen.dart';
import 'battery_alerts_screen.dart';
import 'support_screen.dart';
import 'main_screen.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const SettingsScreen(),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    final currentLang = LocaleProvider.supportedLanguages.firstWhere(
          (l) => l['code'] == localeProvider.locale.languageCode,
      orElse: () => LocaleProvider.supportedLanguages.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          T.of(context, 'settings'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => HomeNavigatorScope.of(context)?.goHome(),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
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
                    color: isDark
                        ? AppColors.textMainDark
                        : AppColors.textMainLight,
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

          _buildSectionHeader(
            context,
            T.of(context, 'app_settings'),
          ),

          _buildSettingsTile(
            context,
            Icons.notifications_rounded,
            T.of(context, 'notifications'),
            "Manage alerts & sounds",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),

          _buildSettingsTile(
            context,
            Icons.security_rounded,
            T.of(context, 'privacy'),
            "Safe zones, data sharing",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacySecurityScreen(),
                ),
              );
            },
          ),

          _buildSettingsTile(
            context,
            Icons.dark_mode_rounded,
            T.of(context, 'dark_mode'),
            "Switch app appearance",
            actionWidget: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              activeColor: AppColors.primaryBlue,
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),

          _buildSettingsTile(
            context,
            Icons.language_rounded,
            T.of(context, 'language'),
            "${currentLang['flag']} ${currentLang['name']}",
            onTap: () {
              _showLanguagePicker(
                context,
                localeProvider,
              );
            },
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(
            context,
            T.of(context, 'device_settings'),
          ),

          _buildSettingsTile(
            context,
            Icons.bluetooth_rounded,
            T.of(context, 'collar_management'),
            "Connected devices",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CollarManagementScreen(),
                ),
              );
            },
          ),

          _buildSettingsTile(
            context,
            Icons.battery_charging_full_rounded,
            T.of(context, 'battery_alerts'),
            "Low power notifications",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BatteryAlertsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          _buildSectionHeader(context, "ACCOUNT"),

          _buildSettingsTile(
            context,
            Icons.help_outline_rounded,
            T.of(context, 'support'),
            "FAQ, contact us",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SupportScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.errorRed.withValues(alpha: 0.1),
              foregroundColor: AppColors.errorRed,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.errorRed.withValues(alpha: 0.3),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                    (route) => false,
              );
            },
            child: const Text(
              "Log Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context,
      LocaleProvider localeProvider,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            16,
            24,
            32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...LocaleProvider.supportedLanguages.map((lang) {
                final isSelected =
                    localeProvider.locale.languageCode ==
                        lang['code'];

                return ListTile(
                  leading: Text(
                    lang['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(lang['name']!),
                  trailing: isSelected
                      ? const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryBlue,
                  )
                      : null,
                  onTap: () {
                    localeProvider.setLocale(
                      Locale(lang['code']!),
                    );

                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
      BuildContext context,
      String title,
      ) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 12,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDark
              ? AppColors.textSubDark
              : AppColors.textSubLight,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle, {
        VoidCallback? onTap,
        Widget? actionWidget,
      }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryBlue,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textMainDark
                          : AppColors.textMainLight,
                    ),
                  ),

                  Text(
                    subtitle,
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

            actionWidget ??
                const Icon(
                  Icons.chevron_right_rounded,
                ),
          ],
        ),
      ),
    );
  }
}