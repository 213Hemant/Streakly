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

  // Frequency Options.
  final List<String> _frequencyOptions = ['daily', 'weekdays', 'weekends'];

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Habit Name Field.
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value!.trim(),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter a habit name'
                    : null,
              ),
              const SizedBox(height: 16),
              // Frequency Dropdown.
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                value: _frequency,
                items: _frequencyOptions
                    .map((frequency) => DropdownMenuItem(
                          value: frequency,
                          child: Text(frequency),
                        ))
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
                          // Create a new Habit instance.
                          Habit habit = Habit(
                            id: '',
                            name: _name,
                            frequency: _frequency,
                            createdAt: DateTime.now(),
                          );
                          // Save the habit using FirestoreService.
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
