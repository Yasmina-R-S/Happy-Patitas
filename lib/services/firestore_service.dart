import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Pets
  Stream<List<Pet>> getPets(String userId) {
    return _db
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Pet.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addPet(Pet pet) {
    return _db.collection('pets').add(pet.toMap());
  }

  Future<void> updatePet(Pet pet) {
    return _db.collection('pets').doc(pet.id).update(pet.toMap());
  }

  Future<void> deletePet(String petId) {
    return _db.collection('pets').doc(petId).delete();
  }
}