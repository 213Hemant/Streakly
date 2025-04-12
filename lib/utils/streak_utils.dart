// Calculates the current streak (consecutive check-ins ending with today).
int calculateCurrentStreak(List<DateTime> checkIns) {
  if (checkIns.isEmpty) return 0;
  List<DateTime> sorted = List.from(checkIns)..sort((a, b) => a.compareTo(b));
  
  // Normalize dates (ignore time portion)
  List<DateTime> normalized = sorted
      .map((d) => DateTime(d.year, d.month, d.day))
      .toList();

  DateTime today = DateTime.now();
  DateTime normalizedToday = DateTime(today.year, today.month, today.day);
  
  int streak = 0;
  DateTime expectedDate = normalizedToday;
  // Loop backwards through normalized dates.
  for (int i = normalized.length - 1; i >= 0; i--) {
    if (normalized[i] == expectedDate) {
      streak++;
      expectedDate = expectedDate.subtract(const Duration(days: 1));
    } else if (normalized[i].isBefore(expectedDate)) {
      // A gap breaks the streak.
      break;
    }
  }
  return streak;
}

// Calculates the best (longest) streak from the check-ins.
int calculateBestStreak(List<DateTime> checkIns) {
  if (checkIns.isEmpty) return 0;
  List<DateTime> sorted = List.from(checkIns)..sort((a, b) => a.compareTo(b));
  List<DateTime> normalized =
      sorted.map((d) => DateTime(d.year, d.month, d.day)).toList();

  int best = 1;
  int current = 1;

  for (int i = 1; i < normalized.length; i++) {
    if (normalized[i].difference(normalized[i - 1]).inDays == 1) {
      current++;
    } else if (normalized[i].difference(normalized[i - 1]).inDays > 1) {
      if (current > best) best = current;
      current = 1;
    }
  }
  if (current > best) best = current;
  return best;
}

// Optional: Computes all consecutive streak intervals (history).
List<int> calculateStreakIntervals(List<DateTime> checkIns) {
  if (checkIns.isEmpty) return [];
  
  List<DateTime> sorted = List.from(checkIns)..sort((a, b) => a.compareTo(b));
  List<DateTime> normalized =
      sorted.map((d) => DateTime(d.year, d.month, d.day)).toList();

  List<int> streaks = [];
  int currentStreak = 1;

  for (int i = 1; i < normalized.length; i++) {
    if (normalized[i].difference(normalized[i - 1]).inDays == 1) {
      currentStreak++;
    } else {
      streaks.add(currentStreak);
      currentStreak = 1;
    }
  }
  streaks.add(currentStreak);
  return streaks;
}
