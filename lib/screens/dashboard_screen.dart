import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';
import '../models/habit.dart';
import '../widgets/add_habit_card.dart';
import 'add_habit_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final String userId = authProvider.user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Streakly !!'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await authProvider.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder<List<Habit>>(
        stream: FirestoreService().getHabits(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final habits = snapshot.data ?? [];
          return habits.isEmpty
              ? const Center(child: Text('No habits added yet.'))
              : ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    return AddHabitCard(habit: habits[index]);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Habit screen.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
