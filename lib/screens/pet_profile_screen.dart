import 'dart:io';
import 'vaccine_screen.dart';
import 'package:flutter/material.dart';
import '../utils/translations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet_model.dart';
import '../providers/pet_provider.dart';
import '../providers/pet_firebase_provider.dart';
import '../utils/colors.dart';
import '../widgets/pet_mood_widget.dart';
import '../widgets/timeline_card.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/info_card.dart';
import '../services/local_picture_service.dart';
import '../providers/navigation_provider.dart';

class PetProfileScreen extends StatefulWidget {
  final Pet pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  bool _isLightOn = false;
  bool _isLostMode = false;

  Future<void> _changePetPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final localService = LocalPictureService();
        final fileName = await localService.saveImageLocally(File(image.path), 'pet_${widget.pet.id}');
        
        if (!mounted) return;
        
        await context.read<PetProvider>().updatePetPhoto(widget.pet.id, fileName);
        
        if (mounted) {
          final updatedPet = widget.pet.copyWith(imageUrl: fileName);
          context.read<PetFirebaseProvider>().updatePetInList(updatedPet);
        }

        if (mounted) Navigator.pop(context); 
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar foto localmente: $e'), backgroundColor: AppColors.errorRed),
          );
        }
      }
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryBlue.withOpacity(0.15),
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 80,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = context.read<PetProvider>();
      petProvider.setCurrentPet(widget.pet);
      petProvider.loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final petProvider = context.watch<PetProvider>();
    final activity = petProvider.activity;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                onPressed: _changePetPhoto,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.pet.id,
                child: FutureBuilder<String?>(
                  future: petProvider.currentPet?.id == widget.pet.id
                      ? petProvider.currentPet?.getFullPhotoPath()
                      : widget.pet.getFullPhotoPath(),
                  builder: (context, snapshot) {
                    final path = snapshot.data;
                    final hasImage = path != null && path.isNotEmpty;

                    if (!hasImage) {
                      return _buildPlaceholder();
                    }

                    if (path.startsWith('http')) {
                      return Image.network(
                        path,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      );
                    } else {
                      return Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (petProvider.currentPet?.id == widget.pet.id
                                    ? petProvider.currentPet!.name
                                    : widget.pet.name),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (petProvider.currentPet?.id == widget.pet.id
                                    ? petProvider.currentPet!.breed
                                    : widget.pet.breed),
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                            ),
                          ),
                        ],
                      ),
                      PetMoodWidget(mood: widget.pet.mood),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem("Age", "${widget.pet.age} years", Icons.cake_rounded),
                      _buildInfoItem("Weight", "${widget.pet.weight} kg", Icons.monitor_weight_rounded),
                      _buildInfoItem("Sex", "Female", Icons.female_rounded),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "AI INSIGHTS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ...petProvider.insights.map((insight) => AIInsightCard(insight: insight.insight)),

                  const SizedBox(height: 24),

                  Text(
                    "ACTIVITY SUMMARY",
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
                      Expanded(
                        child: InfoCard(
                          title: "STEPS",
                          value: activity?.steps.toString() ?? "0",
                          unit: "steps",
                          icon: Icons.directions_walk_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InfoCard(
                          title: "CALORIES",
                          value: activity?.calories.toInt().toString() ?? "0",
                          unit: "kcal",
                          icon: Icons.local_fire_department_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          title: "ACTIVE",
                          value: activity?.activeMinutes.toString() ?? "0",
                          unit: "min",
                          icon: Icons.timer_rounded,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InfoCard(
                          title: "SLEEP",
                          value: "8.5",
                          unit: "hrs",
                          icon: Icons.nights_stay_rounded,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "DEVICE STATUS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (widget.pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (widget.pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bluetooth_connected_rounded,
                          color: widget.pet.deviceStatus == "Online" ? AppColors.statusHappy : AppColors.textSubLight,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Smart Collar v2",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                                ),
                              ),
                              Text(
                                widget.pet.deviceStatus == "Online" ? "Connected • 85% Battery" : "Disconnected",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: widget.pet.deviceStatus == "Online",
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "QUICK ACTIONS",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAction(
                        context,
                        Icons.location_on_rounded,
                        "Locate",
                        AppColors.primaryBlue,
                        onTap: () {
                          Navigator.pop(context);
                          context.read<NavigationProvider>().setIndex(1);
                        },
                      ),
                      _buildQuickAction(
                        context,
                        _isLightOn ? Icons.lightbulb_rounded : Icons.lightbulb_outline_rounded,
                        "Light",
                        Colors.amber,
                        isActive: _isLightOn,
                        onTap: () {
                          setState(() => _isLightOn = !_isLightOn);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_isLightOn ? "Light ON" : "Light OFF"),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      _buildQuickAction(
                        context,
                        Icons.volume_up_rounded,
                        "Alert",
                        Colors.purple,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Sending alert to ${widget.pet.name}'s collar..."),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.purple,
                            ),
                          );
                        },
                      ),
                      _buildQuickAction(
                        context,
                        _isLostMode ? Icons.security_rounded : Icons.security_outlined,
                        "Lost Mode",
                        AppColors.errorRed,
                        isActive: _isLostMode,
                        onTap: () {
                          if (!_isLostMode) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.errorRed,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                title: const Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
                                    SizedBox(width: 10),
                                    Text("¡MODO PERDIDO!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                content: Text(
                                  "¿Estás seguro de activar el Modo Perdido para ${widget.pet.name}? Esto aumentará la frecuencia de GPS y enviará una alerta a los refugios cercanos.",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text("CANCELAR", style: TextStyle(color: Colors.white70)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      setState(() => _isLostMode = true);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("LOST MODE ACTIVATED"),
                                          backgroundColor: AppColors.errorRed,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.errorRed,
                                    ),
                                    child: const Text("ACTIVAR"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            setState(() => _isLostMode = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Lost Mode Deactivated"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PET TIMELINE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => VaccineScreen(pet: widget.pet)));
                        },
                        icon: const Icon(Icons.vaccines_rounded, size: 18),
                        label: Text(T.of(context, 'vaccines')),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TimelineCard(
                    title: "Last Vaccination",
                    time: DateFormat('MMM dd, yyyy').format(widget.pet.lastVaccination),
                    icon: Icons.vaccines_rounded,
                  ),

                  const TimelineCard(
                    title: "Vet Checkup",
                    time: "Oct 12, 2025",
                    icon: Icons.local_hospital_rounded,
                  ),

                  const TimelineCard(
                    title: "Grooming Session",
                    time: "Sep 28, 2025",
                    icon: Icons.content_cut_rounded,
                    isLast: true,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSubLight)),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.2)),
              boxShadow: [
                if (isActive)
                  BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: isActive ? Colors.white : color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
            ),
          ),
        ],
      ),
    );
  }
}
