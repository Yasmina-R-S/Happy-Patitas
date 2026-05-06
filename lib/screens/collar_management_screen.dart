import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../services/database_service.dart';

class CollarManagementScreen extends StatefulWidget {
  const CollarManagementScreen({super.key});

  @override
  State<CollarManagementScreen> createState() => _CollarManagementScreenState();
}

class _CollarManagementScreenState extends State<CollarManagementScreen> {
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'Max\'s Collar',
      'pet': 'Max',
      'status': 'Connected',
      'battery': 87,
      'firmware': '2.1.4',
      'connected': true,
    },
    {
      'name': 'Luna\'s Collar',
      'pet': 'Luna',
      'status': 'Disconnected',
      'battery': 23,
      'firmware': '2.0.9',
      'connected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collar Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showPairDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(context, "CONNECTED DEVICES"),
          ..._devices.map((device) => _buildCollarCard(context, device)),
          const SizedBox(height: 32),
          _buildSectionHeader(context, "ACTIONS"),
          _buildActionTile(
            context,
            Icons.bluetooth_searching_rounded,
            "Scan for New Collars",
            "Add a new PetTrack collar",
            () => _showPairDialog(context),
          ),
          _buildActionTile(
            context,
            Icons.system_update_rounded,
            "Check for Updates",
            "Update collar firmware",
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCollarCard(BuildContext context, Map<String, dynamic> device) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool connected = device['connected'] as bool;
    final int battery = device['battery'] as int;
    final Color batteryColor = battery > 50
        ? AppColors.statusHappy
        : battery > 20
            ? AppColors.statusResting
            : AppColors.errorRed;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: connected
              ? AppColors.statusHappy.withOpacity(0.3)
              : isDark
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
                child: const Icon(Icons.bluetooth_rounded,
                    color: AppColors.primaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                      ),
                    ),
                    Text(
                      device['pet'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (connected ? AppColors.statusHappy : AppColors.textSubLight)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  device['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: connected ? AppColors.statusHappy : AppColors.textSubLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.battery_full_rounded, size: 16, color: batteryColor),
              const SizedBox(width: 4),
              Text(
                "${battery}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: batteryColor,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.system_update_alt_rounded,
                  size: 16,
                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight),
              const SizedBox(width: 4),
              Text(
                "v${device['firmware']}",
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await DatabaseService().guardarCollar(
                    // idDueno omitido → DatabaseService usa currentUser.uid automáticamente
                    idMascota: device['pet'],
                    bateria: device['battery'],
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Datos de ${device['name']} guardados")),
                    );
                  }
                },
                child: const Text("Save",
                    style: TextStyle(color: AppColors.primaryBlue)),
              ),
            ],
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

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
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

  void _showPairDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Pair New Collar",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryBlue),
            SizedBox(height: 16),
            Text("Scanning for nearby collars...",
                textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                // LLamada al servicio de base de datos
                await DatabaseService().guardarCollar(
                  // idDueno omitido → DatabaseService usa currentUser.uid automáticamente
                  idMascota: "pet_nueva",
                  bateria: 100,
                );

                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Collar guardado con éxito!"),
                      backgroundColor: AppColors.statusHappy,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error al guardar: $e"),
                      backgroundColor: AppColors.errorRed,
                    ),
                  );
                }
              }
            },
            child: const Text("Save & Pair"),
          ),
        ],
      ),
    );
  }
}
