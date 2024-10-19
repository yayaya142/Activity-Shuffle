import 'dart:async';

class TimerAPI {
  int defaultTime = 900; // Default timer duration in seconds
  int remainingTime = 900; // Remaining time in seconds
  Timer? _timer; // The Timer object
  bool isPaused = false; // To track if the timer is paused

  // Start the timer for a given duration
  void startTimer(int time) {
    defaultTime = time;
    remainingTime = time;
    isPaused = false;

    _timer?.cancel(); // Cancel any existing timer if running

    // Start a new periodic timer to count down every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
        print('Remaining time: ${getRemainingTimeFormatted()}');
      } else {
        _timer?.cancel();
        print('Timer finished');
      }
    });

    print('Timer started for $time seconds');
  }

  // Reset the timer back to the default time
  void resetTimer() {
    _timer?.cancel();
    remainingTime = defaultTime;
    isPaused = false;
    print('Timer reset to $defaultTime seconds');
  }

  // Pause the timer and save remaining time
  void pauseTimer() {
    if (_timer != null && !isPaused) {
      _timer?.cancel(); // Cancel the current timer to pause it
      isPaused = true; // Mark the timer as paused
      print('Timer paused at ${getRemainingTimeFormatted()}');
    }
  }

  // Resume the timer from the remaining time
  void resumeTimer() {
    if (isPaused) {
      isPaused = false; // Mark the timer as resumed
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          remainingTime--;
          print('Remaining time: ${getRemainingTimeFormatted()}');
        } else {
          _timer?.cancel();
          print('Timer finished');
        }
      });
      print('Timer resumed');
    }
  }

  // Get the remaining time in mm:ss format
  String getRemainingTimeFormatted() {
    int minutes = remainingTime ~/ 60;
    int seconds = remainingTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
