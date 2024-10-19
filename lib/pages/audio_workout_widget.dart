// audio_workout_widget.dart
import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/audio_workout_api.dart';
import 'package:sharp_shooter_pro/services/exercise_api.dart';
import 'package:sharp_shooter_pro/services/shared_preferences_service.dart'
    as globals;

const double setAudioWorkoutTimeTextSize = 20;
const double lastPickedExerciseTextSize = 25;

class AudioWorkoutWidget extends StatefulWidget {
  const AudioWorkoutWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioWorkoutWidgetState createState() => _AudioWorkoutWidgetState();
}

class _AudioWorkoutWidgetState extends State<AudioWorkoutWidget> {
  final AudioWorkoutAPI audioWorkoutAPI = AudioWorkoutAPI(); // Instance of API
  final ExerciseAPI exerciseAPI = ExerciseAPI(); // Instance of exercise API
  RangeValues workoutRange = const RangeValues(30, 120); // Initial range values

  @override
  void initState() {
    super.initState();
    // Load saved min/max times
    audioWorkoutAPI.loadAudioWorkoutTimes().then((_) {
      setState(() {
        workoutRange = RangeValues(
          audioWorkoutAPI.minTime.toDouble(),
          audioWorkoutAPI.maxTime.toDouble(),
        );
      });
    });
  }

  // Function to automatically save the range when it changes
  void _saveWorkoutRange(double newMin, double newMax) {
    audioWorkoutAPI.saveAudioWorkoutTimes(newMin.toInt(), newMax.toInt());
  }

  // Start workout function
  void _startWorkout() async {
    setState(() {
      globals.audioWorkoutActive.value = true; // Enable the "Stop" button
    });

    try {
      // Start audio workout
      await audioWorkoutAPI.startAudioWorkout();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() {
        globals.audioWorkoutActive.value = false; // Reset the workout state
      });
    }
  }

  // Stop workout function
  void _stopWorkout() {
    setState(() {
      globals.audioWorkoutActive.value = false; // Disable the "Stop" button
    });
    audioWorkoutAPI.stopAudioWorkout();
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
              const Text(
                'Cooldown Threshold',
                style: TextStyle(
                    fontSize: setAudioWorkoutTimeTextSize,
                    fontWeight: FontWeight.bold),
              ),

              // RangeSlider for min and max times
              Text(
                  'Waits randomly between ${workoutRange.start.toInt()} and ${workoutRange.end.toInt()} seconds between audio exercise.'),
              RangeSlider(
                values: workoutRange,
                min: 1,
                max: 100,
                divisions: 99, // 1-second increments
                labels: RangeLabels(
                  workoutRange.start.round().toString(),
                  workoutRange.end.round().toString(),
                ),
                onChanged: isWorkoutActive
                    ? null
                    : (RangeValues newRange) {
                        setState(() {
                          workoutRange = newRange;
                        });
                        // Auto-save when the slider is changed
                        _saveWorkoutRange(newRange.start, newRange.end);
                      },
              ),
              const SizedBox(height: 20),

              // Start/Stop buttons
              if (!isWorkoutActive)
                Center(
                  child: ElevatedButton(
                    onPressed: _startWorkout,
                    child: const Text('Start Audio Workout'),
                  ),
                )
              else
                Center(
                  child: ElevatedButton(
                    onPressed: _stopWorkout,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Stop Audio Workout'),
                  ),
                ),

              // Display the last picked exercise
              const SizedBox(height: 10),
              ValueListenableBuilder<String>(
                valueListenable: audioWorkoutAPI.lastPickedExercise,
                builder: (context, lastPickedExercise, child) {
                  return Center(
                    child: Text(
                      lastPickedExercise,
                      style: const TextStyle(
                          fontSize: lastPickedExerciseTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
