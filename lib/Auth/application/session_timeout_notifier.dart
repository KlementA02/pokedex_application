import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionTimeoutNotifier extends StateNotifier<bool> {
  static const _timeoutDuration = Duration(minutes: 10);
  Timer? _timer;

  SessionTimeoutNotifier() : super(false);

  void resetTimer() {
    if (state) return;
    _timer?.cancel();
    _timer = Timer(_timeoutDuration, _lockSession);
  }

  void _lockSession() {
    state = true;
    debugPrint('🔒 Session locked due to inactivity');
  }

  void unlock() {
    state = false;
    resetTimer();
    debugPrint('🔓 Session unlocked');
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
