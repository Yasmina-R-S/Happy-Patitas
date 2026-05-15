import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/translations.dart';
import '../utils/colors.dart';
import '../services/database_service.dart';
import '../providers/pet_firebase_provider.dart';

class CollarManagementScreen extends StatefulWidget {
  const CollarManagementScreen({super.key});

  @override
  State<CollarManagementScreen> createState() =>
      _CollarManagementScreenState();
}

class _CollarManagementScreenState extends State<CollarManagementScreen> {
  // Lista local de collares para mostrar en pantalla
  final List<Map<String, dynamic>> _devices = [
    {
      'name': "Max's Collar",
      'pet': 'Max',
      'status': 'Connected',
      'battery': 87,
      'firmware': '2.1.4',
      'connected': true,
    },
    {
      'name': "Luna's Collar",
      'pet': 'Luna',
      'status': 'Disconnected',
      'battery': 23,
      'firmware': '2.0.9',
      'connected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          T.of(context, 'collar_management'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddCollarSheet(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(context, T.of(context, 'connected_devices')),
          ..._devices.map((d) => _buildCollarCard(context, d)),
          const SizedBox(height: 32),
          _buildSectionHeader(context, T.of(context, 'actions')),
          _buildActionTile(
            context,
            Icons.bluetooth_searching_rounded,
            T.of(context, 'scan_new_collars'),
            T.of(context, 'add_new_collar'),
            () => _showAddCollarSheet(context),
          ),
          _buildActionTile(
            context,
            Icons.system_update_rounded,
            T.of(context, 'check_updates'),
            T.of(context, 'update_firmware'),
            () {},
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCollarSheet(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Añadir Collar'),
      ),
    );
  }

  // ── Tarjeta de cada collar ────────────────────────────────────────────────

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
                        color: isDark
                            ? AppColors.textMainDark
                            : AppColors.textMainLight,
                      ),
                    ),
                    Text(
                      device['pet'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.textSubDark
                            : AppColors.textSubLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (connected
                          ? AppColors.statusHappy
                          : AppColors.textSubLight)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  connected
                      ? T.of(context, 'connected')
                      : T.of(context, 'disconnected'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        connected ? AppColors.statusHappy : AppColors.textSubLight,
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
                '$battery%',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: batteryColor),
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
                    color: isDark
                        ? AppColors.textSubDark
                        : AppColors.textSubLight),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await DatabaseService().guardarCollar(
                    idMascota: device['pet'],
                    bateria: device['battery'],
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${T.of(context, 'datos_guardados')} ${device['name']}'),
                    ));
                  }
                },
                child: Text(T.of(context, 'save'),
                    style: const TextStyle(color: AppColors.primaryBlue)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers UI ────────────────────────────────────────────────────────────

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

  Widget _buildActionTile(BuildContext context, IconData icon, String title,
      String subtitle, VoidCallback onTap) {
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
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : AppColors.ultraLightBlue,
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
                          color: isDark
                              ? AppColors.textMainDark
                              : AppColors.textMainLight)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSubDark
                              : AppColors.textSubLight)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSubLight),
          ],
        ),
      ),
    );
  }

  // ── Bottom sheet: formulario para añadir collar + mascota ─────────────────

  void _showAddCollarSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Controllers mascota
    final petNameCtrl = TextEditingController();
    final razaCtrl = TextEditingController(text: 'Sin especificar');
    final edadCtrl = TextEditingController(text: '1');
    final pesoCtrl = TextEditingController(text: '5.0');

    // Controllers collar
    final collarNameCtrl = TextEditingController();
    final batteryCtrl = TextEditingController(text: '100');
    final firmwareCtrl = TextEditingController(text: '2.1.4');
    bool isConnected = true;
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bg = isDark ? AppColors.surfaceDark : Colors.white;

          return Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // Título
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.pets_rounded,
                              color: AppColors.primaryBlue, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Añadir Collar y Mascota',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textMainDark
                                      : AppColors.textMainLight,
                                ),
                              ),
                              Text(
                                'La mascota aparecerá en "Mis Mascotas"',
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
                      ]),

                      const SizedBox(height: 24),

                      // ─ Sección mascota ─
                      _label('🐾  DATOS DE LA MASCOTA', isDark),
                      const SizedBox(height: 12),

                      _field(
                        ctrl: petNameCtrl,
                        label: 'Nombre de la mascota',
                        hint: 'Ej. Max',
                        icon: Icons.pets_rounded,
                        isDark: isDark,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Escribe el nombre'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      _field(
                        ctrl: razaCtrl,
                        label: 'Raza',
                        hint: 'Ej. Golden Retriever',
                        icon: Icons.category_rounded,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      Row(children: [
                        Expanded(
                          child: _field(
                            ctrl: edadCtrl,
                            label: 'Edad (años)',
                            hint: '1',
                            icon: Icons.cake_rounded,
                            isDark: isDark,
                            keyboard: TextInputType.number,
                            validator: (v) {
                              if (int.tryParse(v ?? '') == null) {
                                return 'Número entero';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            ctrl: pesoCtrl,
                            label: 'Peso (kg)',
                            hint: '5.0',
                            icon: Icons.monitor_weight_rounded,
                            isDark: isDark,
                            keyboard: const TextInputType.numberWithOptions(
                                decimal: true),
                            validator: (v) {
                              if (double.tryParse(v ?? '') == null) {
                                return 'Número válido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),

                      const SizedBox(height: 20),

                      // ─ Sección collar ─
                      _label('📡  DATOS DEL COLLAR', isDark),
                      const SizedBox(height: 12),

                      _field(
                        ctrl: collarNameCtrl,
                        label: 'Nombre del collar',
                        hint: 'Ej. Collar de Max',
                        icon: Icons.label_outline_rounded,
                        isDark: isDark,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Escribe un nombre'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      Row(children: [
                        Expanded(
                          child: _field(
                            ctrl: batteryCtrl,
                            label: 'Batería (%)',
                            hint: '100',
                            icon: Icons.battery_charging_full_rounded,
                            isDark: isDark,
                            keyboard: TextInputType.number,
                            validator: (v) {
                              final n = int.tryParse(v ?? '');
                              if (n == null || n < 0 || n > 100) {
                                return '0 – 100';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            ctrl: firmwareCtrl,
                            label: 'Firmware',
                            hint: '2.1.4',
                            icon: Icons.system_update_alt_rounded,
                            isDark: isDark,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),

                      // Toggle conectado
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : AppColors.ultraLightBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(children: [
                          Icon(Icons.wifi_rounded,
                              color: isConnected
                                  ? AppColors.statusHappy
                                  : AppColors.textSubLight,
                              size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Estado: ${isConnected ? 'Conectado' : 'Desconectado'}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textMainDark
                                    : AppColors.textMainLight,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: isConnected,
                            activeColor: AppColors.statusHappy,
                            onChanged: (v) =>
                                setModal(() => isConnected = v),
                          ),
                        ]),
                      ),

                      const SizedBox(height: 28),

                      // Botón guardar
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: isSaving
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  setModal(() => isSaving = true);

                                  final petName = petNameCtrl.text.trim();
                                  final collarName = collarNameCtrl.text.trim();
                                  final raza = razaCtrl.text.trim();
                                  final edad = int.parse(edadCtrl.text.trim());
                                  final peso =
                                      double.parse(pesoCtrl.text.trim());
                                  final battery =
                                      int.parse(batteryCtrl.text.trim());
                                  final firmware = firmwareCtrl.text.trim();

                                  try {
                                    // 1️⃣ Guardar mascota en Firebase
                                    await context
                                        .read<PetFirebaseProvider>()
                                        .addPet(
                                          nombre: petName,
                                          raza: raza,
                                          edad: edad,
                                          peso: peso,
                                          deviceStatus: isConnected
                                              ? 'Online'
                                              : 'Offline',
                                        );

                                    // 2️⃣ Guardar collar en Firebase
                                    await DatabaseService().guardarCollar(
                                      idMascota: petName,
                                      bateria: battery,
                                    );

                                    // 3️⃣ Añadir a la lista local de collares
                                    setState(() {
                                      _devices.add({
                                        'name': collarName,
                                        'pet': petName,
                                        'status': isConnected
                                            ? 'Connected'
                                            : 'Disconnected',
                                        'battery': battery,
                                        'firmware': firmware,
                                        'connected': isConnected,
                                      });
                                    });
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: AppColors.errorRed,
                                      ));
                                    }
                                    setModal(() => isSaving = false);
                                    return;
                                  }

                                  if (ctx.mounted) Navigator.pop(ctx);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '✓ $petName y $collarName añadidos'),
                                      backgroundColor: AppColors.statusHappy,
                                    ));
                                  }
                                },
                          child: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Añadir Collar y Mascota',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Pequeños helpers de UI del formulario ─────────────────────────────────

  Widget _label(String text, bool isDark) => Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
        ),
      );

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      validator: validator,
      style: TextStyle(
          color: isDark ? AppColors.textMainDark : AppColors.textMainLight),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        labelStyle: TextStyle(
            color: isDark ? AppColors.textSubDark : AppColors.textSubLight),
        hintStyle: TextStyle(
            color: isDark
                ? AppColors.textSubDark.withOpacity(0.5)
                : AppColors.textSubLight.withOpacity(0.5)),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.ultraLightBlue,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.errorRed, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: AppColors.errorRed, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
