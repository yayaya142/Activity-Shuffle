import 'dart:async';
import 'dart:math'; // For generating random numbers
import 'package:sharp_shooter_pro/services/shared_preferences_service.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import for text-to-speech

class AudioWorkoutAPI {
  int minTime = 30; // Default minimum value in seconds
  int maxTime = 120; // Default maximum value in seconds
  bool _isWorkoutActive = false; // To track if the workout is running
  FlutterTts flutterTts = FlutterTts(); // Text-to-Speech instance

  AudioWorkoutAPI() {
    // Load saved min/max values from SharedPreferences
    loadAudioWorkoutTimes();
  }

  // Load saved min and max values
  Future<void> loadAudioWorkoutTimes() async {
    int? savedMinTime = SharedPreferencesService().getInt('minTime');
    int? savedMaxTime = SharedPreferencesService().getInt('maxTime');

    if (savedMinTime != null) {
      minTime = savedMinTime;
    }

    if (savedMaxTime != null) {
      maxTime = savedMaxTime;
    }
  }

  // Save min and max values
  Future<void> saveAudioWorkoutTimes(int newMinTime, int newMaxTime) async {
    minTime = newMinTime;
    maxTime = newMaxTime;

    await SharedPreferencesService().saveInt('minTime', minTime);
    await SharedPreferencesService().saveInt('maxTime', maxTime);
  }

  // Function to pick a random time between min and max
  int getRandomTimeInSeconds() {
    final random = Random();
    return minTime +
        random
            .nextInt(maxTime - minTime + 1); // Random time between min and max
  }

  // Function to randomly pick an exercise from the list of selected exercises
  String getRandomExercise(List<String> selectedExercises) {
    final random = Random();
    return selectedExercises[random.nextInt(selectedExercises.length)];
  }

  // Function to start the workout
  Future<void> startAudioWorkout() async {
    // Load the latest selected exercises from SharedPreferences
    List<String> selectedExercises =
        SharedPreferencesService().getStringList('selectedExercises') ?? [];

    if (selectedExercises.isEmpty) {
      throw Exception("No exercises selected.");
    }

    _isWorkoutActive = true;
    print("Workout started");

    // Wait 5 seconds before starting the workout loop
    await Future.delayed(const Duration(seconds: 5));

    // Workout loop
    while (_isWorkoutActive) {
      final int waitTime = getRandomTimeInSeconds();
      print("Waiting for $waitTime seconds");

      // Wait for a random time between min and max
      await Future.delayed(Duration(seconds: waitTime));

      // Pick a random exercise and speak it out loud
      final String exerciseName = getRandomExercise(selectedExercises);
      print("Selected exercise: $exerciseName");
      await flutterTts.speak(exerciseName);

      // Wait for another random time before repeating
      if (_isWorkoutActive) {
        await Future.delayed(Duration(seconds: getRandomTimeInSeconds()));
      }
    }
  }

  // Function to stop the workout
  void stopAudioWorkout() {
    _isWorkoutActive = false;
    print("Workout stopped");
  }
}
