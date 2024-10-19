// home.dart
import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/pages/audio_workout_widget.dart';
import 'package:sharp_shooter_pro/pages/exercise_widget.dart';
import 'package:sharp_shooter_pro/pages/timer_widget.dart';
import 'package:sharp_shooter_pro/theme.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Activity Shuffle')),
        backgroundColor: ThemeColors().appBarColor,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TimerWidget(),
            ExerciseWidget(),
            AudioWorkoutWidget(),
          ],
        ),
      ),
    );
  }
}
