import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';
import '../utils/streak_utils.dart';
import 'streak_display.dart';

class AddHabitCard extends StatelessWidget {
  final Habit habit;
  const AddHabitCard({Key? key, required this.habit}) : super(key: key);
  
  bool _isCheckedInToday(Habit habit) {
    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);
    return habit.checkIns.any((d) {
      DateTime normalized = DateTime(d.year, d.month, d.day);
      return normalized.isAtSameMomentAs(normalizedToday);
    });
  }

  void _showStreakHistory(BuildContext context, Habit habit) {
    // Calculate the streak intervals using the utility function.
    List<int> intervals = calculateStreakIntervals(habit.checkIns);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Streak History'),
        content: intervals.isEmpty
            ? const Text('No streak history available.')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: intervals.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.whatshot),
                      title: Text('Streak: ${intervals[index]} days'),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool checkedIn = _isCheckedInToday(habit);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user!.uid;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit details and streak display.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Frequency: ${habit.frequency}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                StreakDisplay(
                  currentStreak: habit.currentStreak,
                  bestStreak: habit.bestStreak,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons: Delete, Mark as Done/Reset Today, and View History.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delete Habit button.
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Habit',
                  onPressed: () async {
                    bool? confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Habit'),
                          content: const Text('Are you sure you want to delete this habit?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmed == true) {
                      await FirestoreService().deleteHabit(userId, habit.id);
                    }
                  },
                ),
                // Mark as Done/Reset Today button.
                checkedIn
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          await FirestoreService().resetTodayCheckIn(userId, habit);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset Today'),
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          await FirestoreService().checkInHabit(userId, habit);
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Mark as Done'),
                      ),
                // Button to view streak history.
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: 'View Streak History',
                  onPressed: () {
                    _showStreakHistory(context, habit);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
