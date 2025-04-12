import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String frequency; // e.g., "daily", "weekdays", "weekends"
  final DateTime createdAt;
  final List<DateTime> checkIns;
  final int currentStreak;
  final int bestStreak;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.createdAt,
    this.checkIns = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  // Deserialize Firestore document into a Habit.
  factory Habit.fromMap(Map<String, dynamic> data, String documentId) {
    return Habit(
      id: documentId,
      name: data['name'] as String,
      frequency: data['frequency'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      currentStreak: data['currentStreak'] ?? 0,
      bestStreak: data['bestStreak'] ?? 0,
      checkIns: data['checkIns'] != null
          ? (data['checkIns'] as List<dynamic>)
              .map((e) => DateTime.parse(e as String))
              .toList()
          : [],
    );
  }

  // Serialize Habit object for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'frequency': frequency,
      'createdAt': createdAt,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      // Save checkIns as list of ISO8601 strings.
      'checkIns': checkIns.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Create a copy with updated values.
  Habit copyWith({
    String? id,
    String? name,
    String? frequency,
    DateTime? createdAt,
    List<DateTime>? checkIns,
    int? currentStreak,
    int? bestStreak,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      createdAt: createdAt ?? this.createdAt,
      checkIns: checkIns ?? this.checkIns,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }
}
