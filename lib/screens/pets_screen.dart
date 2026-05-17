import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../widgets/pet_card.dart';
import '../providers/user_provider.dart';
import '../providers/pet_firebase_provider.dart';
import '../utils/colors.dart';
import 'pet_profile_screen.dart';
import 'collar_management_screen.dart';

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
      final user = context.read<UserProvider>().user;
      if (user != null) {
        context.read<PetFirebaseProvider>().fetchPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final petFbProvider = context.watch<PetFirebaseProvider>();
    // Solo mostramos mascotas de Firebase para que la eliminación sea real y definitiva
    final allPets = petFbProvider.pets;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () async {
              // Solo cerrar sesión en Firebase.
              // AuthGate escucha authStateChanges y redirigirá
              // automáticamente a LoginScreen, garantizando que
              // al volver a iniciar sesión se llame fetchPets() de nuevo.
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar Sesión',
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
