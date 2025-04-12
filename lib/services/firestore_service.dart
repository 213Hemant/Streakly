import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new habit for the user.
  Future<void> addHabit(String userId, Habit habit) async {
    try {
      await _firestore.collection('users').doc(userId).collection('habits').add({
        ...habit.toMap(),
        'createdAt': habit.createdAt,  // Ensure createdAt is added
      });
    } catch (e) {
      print("Error adding habit: $e");
      throw Exception("Failed to add habit");
    }
  }

  // Stream a list of habits for the given user.
  Stream<List<Habit>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: true)  // Added descending order
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Habit.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Update habit data (for example, when marking a habit as done)
  Future<void> updateHabit(String userId, Habit habit) async {
    try {
      await _firestore.collection('users').doc(userId).collection('habits').doc(habit.id).update(habit.toMap());
    } catch (e) {
      print("Error updating habit: $e");
      throw Exception("Failed to update habit");
    }
  }
}
