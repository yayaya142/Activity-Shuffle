import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // For CupertinoPicker
import 'package:sharp_shooter_pro/services/timer_api.dart';

class TimerWidget extends StatefulWidget {
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
    _uiUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
        timerAPI.startTimer(selectedMinutes *
            60); // Start the timer with the selected time in seconds
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
        return Container(
          height: 250,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Select Custom Time (minutes)',
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
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Start the timer with the selected custom time
                  setState(() {
                    timerAPI.startTimer(
                        customMinutes * 60); // Start timer in seconds
                    isTimerStarted = true; // Mark timer as started
                    Navigator.pop(context); // Close the bottom sheet
                  });
                },
                child: Text('Set Timer'),
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
      timerAPI.resumeTimer(); // Resume the timer in the API
      isTimerPaused = false; // Unmark paused
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Display the remaining time
        Text(
          'Time: ${timerAPI.getRemainingTimeFormatted()}',
        ),

        SizedBox(height: 20),

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

        SizedBox(height: 20),

        // Show the control buttons based on timer state (started/paused)
        if (isTimerStarted && !isTimerPaused) ...[
          // Pause button with icon
          IconButton(
            icon: Icon(Icons.pause, size: 40, color: Colors.blue), // Pause icon
            onPressed: _pauseTimer,
          ),
        ] else if (isTimerPaused) ...[
          // Resume button with icon
          IconButton(
            icon: Icon(Icons.play_arrow,
                size: 40, color: Colors.green), // Play icon
            onPressed: _resumeTimer,
          ),
          // Reset button with icon
          IconButton(
            icon: Icon(Icons.replay,
                size: 40, color: Colors.red), // Replay/Reset icon
            onPressed: _resetTimer,
          ),
        ],

        // Show reset button if the timer has been paused or completed
        if (!isTimerStarted && isTimerPaused)
          IconButton(
            icon: Icon(Icons.replay, size: 40, color: Colors.red), // Reset icon
            onPressed: _resetTimer,
          ),
      ],
    );
  }

  // Helper method to build each time option button
  Widget _buildTimeOptionButton(String time) {
    return ElevatedButton(
      onPressed: () => _onTimeButtonPressed(time),
      style: ElevatedButton.styleFrom(// Highlight the selected button
          ),
      child: Text(time == 'Custom' ? time : '$time min'),
    );
  }
}
