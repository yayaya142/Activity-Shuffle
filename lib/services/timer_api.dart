import 'dart:async';
import 'dart:ui';
import 'package:just_audio/just_audio.dart';

class TimerAPI {
  int defaultTime = 900; // Default timer duration in seconds
  int remainingTime = 900; // Remaining time in seconds
  Timer? _timer; // The Timer object
  bool isPaused = false; // To track if the timer is paused
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance
  VoidCallback? onTimerComplete; // Callback for timer completion

  // Start the timer for a given duration
  void startTimer(int time, {VoidCallback? onComplete}) {
    defaultTime = time;
    remainingTime = time;
    isPaused = false;
    onTimerComplete = onComplete;

    _timer?.cancel(); // Cancel any existing timer if running

    // Start a new periodic timer to count down every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        _timer?.cancel();
        playSound(); // Play sound when timer finishes
        if (onTimerComplete != null) {
          onTimerComplete!(); // Call the completion callback
        }
      }
    });
  }

  // Reset the timer back to the default time
  void resetTimer() {
    _timer?.cancel();
    remainingTime = defaultTime;
    isPaused = false;
  }

  // Pause the timer and save remaining time
  void pauseTimer() {
    if (_timer != null && !isPaused) {
      _timer?.cancel(); // Cancel the current timer to pause it
      isPaused = true; // Mark the timer as paused
    }
  }

  // Resume the timer from the remaining time
  void resumeTimer() {
    if (isPaused) {
      isPaused = false; // Mark the timer as resumed
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _timer?.cancel();
          playSound(); // Play sound when timer finishes
          if (onTimerComplete != null) {
            onTimerComplete!(); // Call the completion callback
          }
        }
      });
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

  // Play a sound when the timer finishes
  void playSound() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/timer_finish.mp3');
      _audioPlayer.play();
    } catch (e) {
      // ignore: avoid_print
      print('Error playing sound: $e');
    }
  }
}
