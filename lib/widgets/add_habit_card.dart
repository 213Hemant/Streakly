import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'streak_display.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Display habit name and frequency
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ensure habit name is not null or empty
                  Text(
                    habit.name.isNotEmpty ? habit.name : 'No Name Provided',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  // Ensure frequency is valid
                  Text(
                    'Frequency: ${habit.frequency.isNotEmpty ? habit.frequency : 'N/A'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Display current streak using the streak widget
            StreakDisplay(
              // Safeguard against null streak values by defaulting to 0
              currentStreak: habit.currentStreak,
              bestStreak: habit.bestStreak,
            ),
          ],
        ),
      ),
    );
  }
}
