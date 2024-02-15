import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class SleepTimer {
  final AudioPlayer _audioPlayer;

  final _timer = BehaviorSubject.seeded(Duration.zero);
  final _isTimerActive = BehaviorSubject.seeded(false);

  Stream<Duration> get remainingDuration => _timer.stream;

  SleepTimer(this._audioPlayer);

  void init() {
    _timer.map((event) => event >= Duration.zero).pipe(_isTimerActive);
    Timer.periodic(_timer.value, (timer) { });
  }

  setTimer(Duration duration) {
    if (duration <= Duration.zero) {
      return;
    }
    _timer.add(_timer.value + duration);
  }

  extendTimer(Duration duration) {
    setTimer(duration);
  }

  removeTimer() {
    _timer.add(Duration.zero);
  }

  afterTrack() {
    // audioPlayer.bufferedPosition
  }
}
