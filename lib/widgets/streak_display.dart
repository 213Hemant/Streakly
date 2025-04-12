import 'package:flutter/material.dart';

class StreakDisplay extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  
  const StreakDisplay({
    Key? key,
    required this.currentStreak,
    required this.bestStreak,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '🔥 $currentStreak',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Best: $bestStreak',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
