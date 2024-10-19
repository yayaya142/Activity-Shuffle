// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sharp_shooter_pro/services/timer_api.dart';
import 'package:sharp_shooter_pro/theme.dart'; // For CupertinoPicker

const double timerFunctionButtonSize = 20.0;
const double timerTextSize = 50.0;

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  TimerAPI timerAPI = TimerAPI();
  late Timer _uiUpdateTimer; // Timer to update the UI every second
  String selectedTime = '10'; // Default selected time
  int customMinutes = 1; // Store the selected custom time (default 1 minute)
  bool isTimerStarted = false; // Track if the timer is started
  bool isTimerPaused = false; // Track if the timer is paused

  @override
  void initState() {
    super.initState();
    // Set up a UI timer that updates every second
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer.cancel(); // Cancel the UI update timer when done
    super.dispose();
  }

  // Function to handle the time selection buttons
  void _onTimeButtonPressed(String time) {
    setState(() {
      selectedTime = time;
      if (time != 'Custom') {
        int selectedMinutes = int.parse(time);
        timerAPI.startTimer(selectedMinutes * 60,
            onComplete:
                _resetTimer); // Start the timer with the selected time in seconds
        isTimerStarted = true; // Mark timer as started
      } else {
        // Open wheel slider for custom time selection
        _showCustomTimePicker();
      }
    });
  }

  // Show modal bottom sheet with a wheel slider for custom time
  void _showCustomTimePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Select Custom Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40, // Height of each item in the wheel
                  scrollController: FixedExtentScrollController(
                    initialItem: customMinutes -
                        1, // Preselect the previously chosen time
                  ),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      customMinutes =
                          index + 1; // Update customMinutes (min 1 minute)
                    });
                  },
                  children: List<Widget>.generate(60, (int index) {
                    return Center(
                      child: Text(
                        '${index + 1} min',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Start the timer with the selected custom time
                  setState(() {
                    timerAPI.startTimer(customMinutes * 60,
                        onComplete: _resetTimer); // Start timer in seconds
                    isTimerStarted = true; // Mark timer as started
                    Navigator.pop(context); // Close the bottom sheet
                  });
                },
                child: const Text('Set Timer'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to reset the timer and show the time selection options again
  void _resetTimer() {
    setState(() {
      timerAPI.resetTimer(); // Reset the timer in the API
      isTimerStarted = false; // Mark timer as not started
      isTimerPaused = false; // Ensure it's not paused either
      selectedTime = '10'; // Reset the selected time to default
    });
  }

  // Function to pause the timer
  void _pauseTimer() {
    setState(() {
      timerAPI.pauseTimer(); // Pause the timer in the API
      isTimerPaused = true; // Mark timer as paused
    });
  }

  // Function to resume the timer
  void _resumeTimer() {
    setState(() {
      timerAPI.resumeTimer();
      isTimerPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isTimerStarted == true)
          Center(
            child: Text(
              timerAPI.getRemainingTimeFormatted(),
              style: const TextStyle(
                fontSize: timerTextSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

        const SizedBox(height: 10),

        // Show the time selection buttons only if the timer hasn't started
        if (!isTimerStarted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeOptionButton('10'),
              _buildTimeOptionButton('15'),
              _buildTimeOptionButton('20'),
              _buildTimeOptionButton('Custom'),
            ],
          ),

        // Show the control buttons based on timer state (started/paused)
        if (isTimerStarted && !isTimerPaused) ...[
          // Pause button centered horizontally
          Center(
            child: IconButton(
              icon: const Icon(Icons.pause,
                  size: timerFunctionButtonSize,
                  color: Colors.blue), // Pause icon
              onPressed: _pauseTimer,
            ),
          ),
        ] else if (isTimerPaused) ...[
          // Row with Resume and Reset buttons centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the row
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow,
                    size: timerFunctionButtonSize,
                    color: Colors.green), // Play icon
                onPressed: _resumeTimer,
              ),
              const SizedBox(width: 30), // Space between buttons
              IconButton(
                icon: const Icon(Icons.replay,
                    size: timerFunctionButtonSize,
                    color: Colors.red), // Replay/Reset icon
                onPressed: _resetTimer,
              ),
            ],
          ),
        ],

        // Show reset button if the timer has been paused or completed
        if (!isTimerStarted && isTimerPaused)
          IconButton(
            icon: const Icon(Icons.replay,
                size: timerFunctionButtonSize, color: Colors.red), // Reset icon
            onPressed: _resetTimer,
          ),
      ],
    );
  }

  // Helper method to build each time option button
  Widget _buildTimeOptionButton(String time) {
    return ElevatedButton(
      onPressed: () => _onTimeButtonPressed(time),
      style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors().timerOptionsBackgroundColor),
      child: Text(time == 'Custom' ? time : '$time min',
          style: TextStyle(color: ThemeColors().timerOptionsTextColor)),
    );
  }
}
