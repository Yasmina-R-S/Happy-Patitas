import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../widgets/pet_card.dart';
import '../providers/pet_firebase_provider.dart';
import '../utils/colors.dart';
import 'pet_profile_screen.dart';
import 'collar_management_screen.dart';
import 'login_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetFirebaseProvider>().fetchPets();
    });
  }

  // Mascotas mock que siempre se muestran (las 3 originales)
  List<Pet> get _staticPets => [
        Pet(
          id: 'static_1',
          name: 'Luna',
          breed: 'Golden Retriever',
          age: 3,
          weight: 28.5,
          imageUrl:
              'https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          mood: PetMood.happy,
          deviceStatus: 'Online',
          lastVaccination: DateTime.now().subtract(const Duration(days: 60)),
        ),
        Pet(
          id: 'static_2',
          name: 'Oliver',
          breed: 'Maine Coon',
          age: 2,
          weight: 8.2,
          imageUrl:
              'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          mood: PetMood.resting,
          deviceStatus: 'Online',
          lastVaccination: DateTime.now().subtract(const Duration(days: 120)),
        ),
        Pet(
          id: 'static_3',
          name: 'Sky',
          breed: 'Parrot',
          age: 1,
          weight: 0.4,
          imageUrl:
              'https://images.unsplash.com/photo-1552728089-57bdde30ebd3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          mood: PetMood.active,
          deviceStatus: 'Offline',
          lastVaccination: DateTime.now().subtract(const Duration(days: 300)),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final petFbProvider = context.watch<PetFirebaseProvider>();
    // Combinar las 3 mascotas fijas + las añadidas desde Firebase
    final allPets = [..._staticPets, ...petFbProvider.pets];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            tooltip: 'Ir al Login',
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CollarManagementScreen()),
              );
              // Al volver, recargar mascotas por si se añadieron nuevas
              if (mounted) context.read<PetFirebaseProvider>().fetchPets();
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryBlue,
        onRefresh: () => context.read<PetFirebaseProvider>().fetchPets(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Cabecera "MIS MASCOTAS"
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 16),
              child: Text(
                'MIS MASCOTAS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                ),
              ),
            ),

            // Lista combinada (estáticas + Firebase)
            ...allPets.map((pet) => PetCard(
                  pet: pet,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PetProfileScreen(pet: pet)),
                  ),
                )),

            // Indicador de carga para mascotas de Firebase
            if (petFbProvider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primaryBlue)),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
