// exercise_widget.dart
// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/exercise_api.dart';
import 'package:sharp_shooter_pro/theme.dart';
import 'package:sharp_shooter_pro/services/shared_preferences_service.dart'
    as globals;

const double selectTodayExercisesSize = 22.0;

class ExerciseWidget extends StatefulWidget {
  const ExerciseWidget({super.key});

  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  ExerciseAPI exerciseAPI = ExerciseAPI();
  List<String> selectedExercises = []; // Track selected exercises

  @override
  void initState() {
    super.initState();
    loadSelectedExercises();
  }

  // Load selected exercises from the API
  void loadSelectedExercises() async {
    await exerciseAPI.loadSelectedExercises();
    setState(() {
      selectedExercises = exerciseAPI.selectedExercises;
    });
  }

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

  // Method to show a confirmation dialog before deleting exercises
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Selected Exercises'),
          content: const Text(
              'Are you sure you want to delete the selected exercises?'),
          actions: [
            TextButton(
              onPressed: () {
                // Confirm deletion
                setState(() {
                  // Delete selected exercises
                  for (String exerciseName in selectedExercises.toList()) {
                    exerciseAPI.deleteExercise(exerciseName);
                  }
                  selectedExercises.clear(); // Clear selections after deletion
                  exerciseAPI
                      .saveSelectedExercises(); // Save updated selections
                });
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Yes, Delete'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel deletion
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
    return ValueListenableBuilder<bool>(
      valueListenable: globals.audioWorkoutActive,
      builder: (context, isWorkoutActive, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for title and Add Exercise button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Select Today\'s Exercises',
                      style: TextStyle(
                          fontSize: selectTodayExercisesSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Add Exercise button
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.green,
                    onPressed: isWorkoutActive ? null : _showAddExerciseDialog,
                  ),
                  IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: isWorkoutActive
                          ? null
                          : _showDeleteConfirmationDialog),
                ],
              ),
              const SizedBox(height: 20),

              // Multi-select choice chips
              Wrap(
                spacing: 8.0, // Space between chips
                children: exerciseAPI.exercises.map((exercise) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0), // Padding between each chip
                    child: ChoiceChip(
                      label: Text(exercise.name),
                      selected: selectedExercises.contains(exercise.name),
                      selectedColor:
                          ThemeColors().selectExerciseButtonColorSelected,
                      backgroundColor:
                          ThemeColors().selectExerciseButtonColorNotSelected,
                      labelStyle: TextStyle(
                        color: selectedExercises.contains(exercise.name)
                            ? ThemeColors().selectExerciseTextColorSelected
                            : ThemeColors().selectExerciseTextColorNotSelected,
                      ),
                      onSelected: isWorkoutActive
                          ? null
                          : (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedExercises.add(exercise.name);
                                  _speakExercise(
                                      exercise.name); // Speak exercise name
                                } else {
                                  selectedExercises.remove(exercise.name);
                                }
                                exerciseAPI.selectedExercises =
                                    selectedExercises;
                                exerciseAPI
                                    .saveSelectedExercises(); // Save updated selections
                              });
                            },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
