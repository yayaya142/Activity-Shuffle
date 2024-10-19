import 'package:sharp_shooter_pro/services/shared_preferences_service.dart';

class AudioWorkoutAPI {
  // Default min and max values in seconds
  int minTime = 30; // Default minimum value
  int maxTime = 120; // Default maximum value

  AudioWorkoutAPI() {
    // Load saved min/max values from SharedPreferences
    loadAudioWorkoutTimes();
  }

  // Function to load min and max values from SharedPreferences
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

  // Function to save min and max values to SharedPreferences
  Future<void> saveAudioWorkoutTimes(int newMinTime, int newMaxTime) async {
    minTime = newMinTime;
    maxTime = newMaxTime;

    await SharedPreferencesService().saveInt('minTime', minTime);
    await SharedPreferencesService().saveInt('maxTime', maxTime);
  }
}
