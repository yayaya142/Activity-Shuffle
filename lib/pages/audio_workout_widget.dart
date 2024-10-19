import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/audio_workout_api.dart';

class AudioWorkoutWidget extends StatefulWidget {
  const AudioWorkoutWidget({super.key});

  @override
  _AudioWorkoutWidgetState createState() => _AudioWorkoutWidgetState();
}

class _AudioWorkoutWidgetState extends State<AudioWorkoutWidget> {
  AudioWorkoutAPI audioWorkoutAPI = AudioWorkoutAPI(); // Instance of API
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
        ],
      ),
    );
  }
}
