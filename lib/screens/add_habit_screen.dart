import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/auth_provider.dart';
import '../services/firestore_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _frequency = 'daily';
  bool _isLoading = false;

  final List<String> _frequencyOptions = ['daily', 'weekdays', 'weekends'];

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Habit Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Habit Name'),
                onSaved: (value) => _name = value!.trim(),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a habit name' : null,
              ),
              const SizedBox(height: 16),
              // Frequency Selection
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Frequency'),
                value: _frequency,
                items: _frequencyOptions
                    .map((frequency) => DropdownMenuItem(value: frequency, child: Text(frequency)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _frequency = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          // Build habit model with current date
                          Habit habit = Habit(
                            id: '', // Make sure the ID is empty when creating a new habit
                            name: _name,
                            frequency: _frequency,
                            createdAt: DateTime.now(),
                          );
                          await FirestoreService().addHabit(userId, habit);
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add Habit'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
