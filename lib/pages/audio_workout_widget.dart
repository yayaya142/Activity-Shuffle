import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/audio_workout_api.dart';
import 'package:sharp_shooter_pro/services/exercise_api.dart';

class AudioWorkoutWidget extends StatefulWidget {
  const AudioWorkoutWidget({super.key});

  @override
  _AudioWorkoutWidgetState createState() => _AudioWorkoutWidgetState();
}

class _AudioWorkoutWidgetState extends State<AudioWorkoutWidget> {
  final AudioWorkoutAPI audioWorkoutAPI = AudioWorkoutAPI(); // Instance of API
  final ExerciseAPI exerciseAPI = ExerciseAPI(); // Instance of exercise API
  RangeValues workoutRange = const RangeValues(30, 120); // Initial range values
  bool isWorkoutActive = false; // To track workout state

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
      isWorkoutActive = true; // Enable the "Stop" button
    });

    try {
      // Start audio workout
      await audioWorkoutAPI.startAudioWorkout();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      setState(() {
        isWorkoutActive = false; // Reset the workout state
      });
    }
  }

  // Stop workout function
  void _stopWorkout() {
    setState(() {
      isWorkoutActive = false; // Disable the "Stop" button
    });
    audioWorkoutAPI.stopAudioWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Audio Workout Time Range',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // RangeSlider for min and max times
          Text(
              'Workout Time Range: ${workoutRange.start.toInt()} - ${workoutRange.end.toInt()} seconds'),
          RangeSlider(
            values: workoutRange,
            min: 1,
            max: 300,
            divisions: 299, // 1-second increments
            labels: RangeLabels(
              workoutRange.start.round().toString(),
              workoutRange.end.round().toString(),
            ),
            onChanged: (RangeValues newRange) {
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
            ElevatedButton(
              onPressed: _startWorkout,
              child: const Text('Start Audio Workout'),
            )
          else
            ElevatedButton(
              onPressed: _stopWorkout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Stop Audio Workout'),
            ),
        ],
      ),
    );
  }
}
