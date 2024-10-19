class TimerAPI {
  int defaultTime = 10;
  int remainingTime = 10;

  // functions to interact with the timer
  void startTimer(int time) {
    print('Timer started for $time seconds');
  }

  void resetTimer() {
    print('Timer reset');
  }

  void pauseTimer() {
    print('Timer paused');
  }

  void resumeTimer() {
    print('Timer resumed');
  }

  String getRemainingTimeFormatted() {
    return '00:00';
  }
}
