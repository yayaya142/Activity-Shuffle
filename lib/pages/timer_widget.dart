// lib/pages/TimerWidget.dart
import 'package:flutter/material.dart';
import 'package:sharp_shooter_pro/services/timer_api.dart';

class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            TimerAPI().startTimer(10);
          },
          child: const Text('Start Timer'),
        ),
        ElevatedButton(
          onPressed: () {
            TimerAPI().resetTimer();
          },
          child: const Text('Reset Timer'),
        ),
        ElevatedButton(
          onPressed: () {
            TimerAPI().pauseTimer();
          },
          child: const Text('Pause Timer'),
        ),
        ElevatedButton(
          onPressed: () {
            TimerAPI().resumeTimer();
          },
          child: const Text('Resume Timer'),
        ),
        Text(
          TimerAPI().getRemainingTimeFormatted(),
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ],
    );
  }
}
