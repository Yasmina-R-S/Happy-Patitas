import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../widgets/pet_card.dart';
import 'pet_profile_screen.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock list of pets
    final List<Pet> pets = [
      Pet(
        id: "1",
        name: "Luna",
        breed: "Golden Retriever",
        age: 3,
        weight: 28.5,
        imageUrl: "https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        mood: PetMood.happy,
        deviceStatus: "Online",
        lastVaccination: DateTime.now().subtract(const Duration(days: 60)),
      ),
      Pet(
        id: "2",
        name: "Oliver",
        breed: "Maine Coon",
        age: 2,
        weight: 8.2,
        imageUrl: "https://images.unsplash.com/photo-1533738363-b7f9aef128ce?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        mood: PetMood.resting,
        deviceStatus: "Online",
        lastVaccination: DateTime.now().subtract(const Duration(days: 120)),
      ),
      Pet(
        id: "3",
        name: "Sky",
        breed: "Parrot",
        age: 1,
        weight: 0.4,
        imageUrl: "https://images.unsplash.com/photo-1552728089-57bdde30ebd3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        mood: PetMood.active,
        deviceStatus: "Offline",
        lastVaccination: DateTime.now().subtract(const Duration(days: 300)),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Pets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          return PetCard(
            pet: pets[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetProfileScreen(pet: pets[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
