// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/exercise_api.dart';

class ExerciseWidget extends StatefulWidget {
  const ExerciseWidget({super.key});

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  ExerciseAPI exerciseAPI = ExerciseAPI();
  String? selectedExercise; // Track the selected exercise

  // Method to show a dialog for adding a new exercise
  void _showAddExerciseDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Exercise Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  try {
                    exerciseAPI.addExercise(name);
                    Navigator.of(context).pop(); // Close dialog
                    setState(() {}); // Refresh the UI
                  } catch (e) {
                    // Handle exception (e.g., exercise already exists)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to speak the selected exercise
  void _speakExercise(String name) async {
    await exerciseAPI.speakExercise(name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Today\'s Exercises',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // List of exercises
        Expanded(
          child: ListView.builder(
            itemCount: exerciseAPI.exercises.length,
            itemBuilder: (context, index) {
              Exercise exercise = exerciseAPI.exercises[index];
              return ListTile(
                title: Text(
                  exercise.name,
                  style: TextStyle(
                    color: selectedExercise == exercise.name
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedExercise =
                        exercise.name; // Update selected exercise
                    _speakExercise(exercise.name); // Speak exercise name
                  });
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      exerciseAPI
                          .deleteExercise(exercise.name); // Delete exercise
                    });
                  },
                ),
              );
            },
          ),
        ),

        // Button to add a new exercise
        ElevatedButton(
          onPressed: _showAddExerciseDialog,
          child: const Text('Add Exercise'),
        ),
      ],
    );
  }
}
