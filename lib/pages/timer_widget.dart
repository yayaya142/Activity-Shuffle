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
  String selectedTime = '15'; // Default selected time
  int customMinutes = 1; // Store the selected custom time (default 1 minute)

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

        // Row with predefined time options: 10, 15, 20, and Custom
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Predefined buttons for 10, 15, 20, and Custom
            _buildTimeOptionButton('10'),
            _buildTimeOptionButton('15'),
            _buildTimeOptionButton('20'),
            _buildTimeOptionButton('Custom'),
          ],
        ),

        SizedBox(height: 20),

        // Buttons for controlling the timer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  timerAPI.startTimer(int.parse(selectedTime) *
                      60); // Start the timer for the selected duration
                });
              },
              child: Text('Start'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  timerAPI.pauseTimer(); // Pause the timer
                });
              },
              child: Text('Pause'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  timerAPI.resumeTimer(); // Resume the timer
                });
              },
              child: Text('Resume'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  timerAPI.resetTimer(); // Reset the timer
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build each time option button
  Widget _buildTimeOptionButton(String time) {
    return ElevatedButton(
      onPressed: () => _onTimeButtonPressed(time),
      style: ElevatedButton.styleFrom(),
      child: Text(time == 'Custom' ? time : '$time min'),
    );
  }
}
