import 'package:flutter_tts/flutter_tts.dart'; // Assuming you're using flutter_tts for text-to-speech

class ExerciseAPI {
  List<Exercise> exercises = [
    Exercise(name: "Target A", ttsFile: "target_a.mp3"),
    Exercise(name: "Target B", ttsFile: "target_b.mp3"),
    Exercise(name: "Target C", ttsFile: "target_c.mp3"),
    Exercise(name: "Target D", ttsFile: "target_d.mp3"),
  ];

  // Text-to-Speech instance
  final FlutterTts flutterTts = FlutterTts();

  // Function to add a new exercise
  void addExercise(String name) {
    if (exercises.any((exercise) => exercise.name == name)) {
      throw Exception("Exercise already exists.");
    }
    // Create a new exercise and add it to the list
    exercises.add(Exercise(name: name, ttsFile: "$name.mp3"));
  }

  // Function to delete an exercise
  void deleteExercise(String name) {
    exercises.removeWhere((exercise) => exercise.name == name);
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
}
