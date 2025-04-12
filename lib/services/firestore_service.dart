import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';
import '../utils/streak_utils.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new habit for the user.
  Future<void> addHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .add(habit.toMap());
  }

  // Stream habits for the user.
  Stream<List<Habit>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Habit.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Update the habit document.
  Future<void> updateHabit(String userId, Habit habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .update(habit.toMap());
  }

  // Mark today as checked in for the habit.
  Future<void> checkInHabit(String userId, Habit habit) async {
    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);
    // If already checked in today, do nothing.
    bool alreadyChecked = habit.checkIns.any((d) {
      DateTime normalized = DateTime(d.year, d.month, d.day);
      return normalized.isAtSameMomentAs(normalizedToday);
    });
    if (alreadyChecked) return;

    // Add today's check-in.
    List<DateTime> updatedCheckIns = List.from(habit.checkIns)..add(normalizedToday);
    // Recalculate streaks.
    int currentStreak = calculateCurrentStreak(updatedCheckIns);
    int bestStreak = calculateBestStreak(updatedCheckIns);
    
    Habit updatedHabit = habit.copyWith(
      checkIns: updatedCheckIns,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
    
    // Update Firestore.
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(updatedHabit.id)
        .update(updatedHabit.toMap());
  }

  // Delete a habit from Firestore.
  Future<void> deleteHabit(String userId, String habitId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .delete();
  }

  // Reset today's check-in in case of error.
  Future<void> resetTodayCheckIn(String userId, Habit habit) async {
    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);
    
    // Remove today's check-in from the list.
    List<DateTime> updatedCheckIns = habit.checkIns.where((d) {
      DateTime normalized = DateTime(d.year, d.month, d.day);
      return !normalized.isAtSameMomentAs(normalizedToday);
    }).toList();

    // Recalculate streaks.
    int currentStreak = calculateCurrentStreak(updatedCheckIns);
    int bestStreak = calculateBestStreak(updatedCheckIns);

    Habit updatedHabit = habit.copyWith(
      checkIns: updatedCheckIns,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
    
    // Update Firestore.
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(updatedHabit.id)
        .update(updatedHabit.toMap());
  }
}
