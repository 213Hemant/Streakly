import 'package:cloud_firestore/cloud_firestore.dart'; // Import to use Timestamp

class Habit {
  final String id;
  final String name;
  final String frequency; // e.g., 'daily', 'weekdays'
  final DateTime createdAt;
  final int currentStreak;
  final int bestStreak;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.createdAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  // Converts Firestore document snapshot to Habit model.
  factory Habit.fromMap(Map<String, dynamic> data, String documentId) {
    // Check if 'createdAt' is a Timestamp, and convert it to DateTime
    var createdAtTimestamp = data['createdAt'];
    DateTime createdAtDateTime;

    // If it's a Timestamp, convert to DateTime
    if (createdAtTimestamp is Timestamp) {
      createdAtDateTime = createdAtTimestamp.toDate();
    } else {
      // If it's already DateTime (maybe from local data), use it directly
      createdAtDateTime = createdAtTimestamp is DateTime
          ? createdAtTimestamp
          : DateTime.now(); // Fallback to current time if no valid date found
    }

    return Habit(
      id: documentId,
      name: data['name'] as String,
      frequency: data['frequency'] as String,
      createdAt: createdAtDateTime,
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
    );
  }

  // Converts Habit model to Map for Firestore saving.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency,
      'createdAt': createdAt, // Firestore will handle DateTime as Timestamp
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
    };
  }
}
