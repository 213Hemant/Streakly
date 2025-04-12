import 'package:flutter/material.dart';

class StreakDisplay extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;

  const StreakDisplay({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Safeguard against null or negative streak values, defaulting to 0 if necessary
        Text(
          '🔥 ${currentStreak >= 0 ? currentStreak : 0}',  // Ensure current streak isn't negative
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        // Same for the best streak
        Text(
          'Best: ${bestStreak >= 0 ? bestStreak : 0}',  // Ensure best streak isn't negative
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
