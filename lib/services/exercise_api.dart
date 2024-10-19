import 'dart:convert'; // For encoding/decoding JSON
import 'package:flutter_tts/flutter_tts.dart'; // Assuming you're using flutter_tts for text-to-speech
import 'package:sharp_shooter_pro/services/shared_preferences_service.dart';

class ExerciseAPI {
  List<Exercise> exercises = [];
  List<String> selectedExercises = [];

  final FlutterTts flutterTts = FlutterTts(); // Text-to-Speech instance

  // Default exercises (cannot be deleted)
  final List<Exercise> defaultExercises = [
    Exercise(name: "Target A", ttsFile: "target_a.mp3"),
    Exercise(name: "Target B", ttsFile: "target_b.mp3"),
    Exercise(name: "Target C", ttsFile: "target_c.mp3"),
    Exercise(name: "Target D", ttsFile: "target_d.mp3"),
  ];

  // Constructor to initialize the API and load saved data
  ExerciseAPI() {
    loadExercises();
    loadSelectedExercises();
  }

  // Load exercises from shared preferences
  Future<void> loadExercises() async {
    List<String>? exercisesJson =
        SharedPreferencesService().getStringList('exercises');
    if (exercisesJson != null && exercisesJson.isNotEmpty) {
      exercises = exercisesJson
          .map((jsonString) => Exercise.fromJson(json.decode(jsonString)))
          .toList();
    } else {
      // If no exercises saved, load the default ones
      exercises = [...defaultExercises];
      saveExercises(); // Save default exercises initially
    }
  }

  // Save exercises to shared preferences
  Future<void> saveExercises() async {
    List<String> exercisesJson =
        exercises.map((exercise) => json.encode(exercise.toJson())).toList();
    await SharedPreferencesService().saveStringList('exercises', exercisesJson);
  }

  // Load selected exercises from shared preferences
  Future<void> loadSelectedExercises() async {
    selectedExercises =
        SharedPreferencesService().getStringList('selectedExercises') ?? [];
  }

  // Save selected exercises to shared preferences
  Future<void> saveSelectedExercises() async {
    await SharedPreferencesService()
        .saveStringList('selectedExercises', selectedExercises);
  }

  // Function to add a new exercise
  void addExercise(String name) {
    if (exercises.any((exercise) => exercise.name == name)) {
      throw Exception("Exercise already exists.");
    }
    exercises.add(Exercise(name: name, ttsFile: "$name.mp3"));
    saveExercises(); // Save updated list
  }

  // Function to delete an exercise (cannot delete default exercises)
  void deleteExercise(String name) {
    if (defaultExercises.any((exercise) => exercise.name == name)) {
      throw Exception("Cannot delete a default exercise.");
    }
    exercises.removeWhere((exercise) => exercise.name == name);
    saveExercises(); // Save updated list
  }

  // Function to speak the exercise name
  Future<void> speakExercise(String name) async {
    await flutterTts.speak(name);
  }
}

// Model class for an Exercise
class Exercise {
  String name;
  String ttsFile;

  Exercise({required this.name, required this.ttsFile});

  // Convert an Exercise to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ttsFile': ttsFile,
    };
  }

  // Create an Exercise from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      ttsFile: json['ttsFile'],
    );
  }
}
