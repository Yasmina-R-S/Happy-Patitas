import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'How do I pair my collar?',
      'a':
          'Go to Settings > Collar Management and tap the + button. Make sure your collar is in pairing mode (hold the button for 3 seconds until it blinks blue).',
    },
    {
      'q': 'Why is the GPS not updating?',
      'a':
          'Ensure the collar has sufficient battery and is within cellular coverage. GPS updates every 30 seconds when moving and every 5 minutes when stationary.',
    },
    {
      'q': 'How accurate is the heart rate monitor?',
      'a':
          'Our sensor is accurate within ±5 BPM. For best results, ensure the collar fits snugly but not too tight — you should be able to fit two fingers underneath.',
    },
    {
      'q': 'Can I share access with family members?',
      'a':
          'Yes! Go to your pet\'s profile and tap "Share Access". You can invite up to 5 trusted contacts.',
    },
    {
      'q': 'How long does the battery last?',
      'a':
          'Battery life depends on GPS usage. With standard tracking, expect 5-7 days. With frequent GPS pings, expect 2-3 days.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Contact options
          _buildSectionHeader(context, "CONTACT US"),
          _buildContactTile(
            context,
            Icons.chat_rounded,
            "Live Chat",
            "Available Mon–Fri, 9am–6pm",
            onTap: () {},
          ),
          _buildContactTile(
            context,
            Icons.email_rounded,
            "Email Support",
            "support@pettrack.app",
            onTap: () {},
          ),
          _buildContactTile(
            context,
            Icons.phone_rounded,
            "Call Us",
            "+1 (800) 123-4567",
            onTap: () {},
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "FREQUENTLY ASKED QUESTIONS"),
          ..._faqs.map((faq) => _buildFaqTile(context, faq['q']!, faq['a']!)),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "RESOURCES"),
          _buildContactTile(
            context,
            Icons.menu_book_rounded,
            "User Guide",
            "Full collar & app documentation",
            onTap: () {},
          ),
          _buildContactTile(
            context,
            Icons.video_library_rounded,
            "Video Tutorials",
            "Step-by-step how-to videos",
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "App version 3.2.1 · Build 204",
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
              ),
            ),
          ),
          const SizedBox(height: 24),
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

  Widget _buildContactTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSubLight),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, String question, String answer) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : AppColors.ultraLightBlue,
        ),
      ),
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
          ),
        ),
        iconColor: AppColors.primaryBlue,
        collapsedIconColor: AppColors.textSubLight,
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
            ),
          ),
        ],
      ),
    );
  }
}
