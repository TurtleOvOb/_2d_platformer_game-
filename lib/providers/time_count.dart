import 'dart:async';

import 'package:riverpod/riverpod.dart';

class Timestate {
  final int? seconds;
  final bool isRunning;

  Timestate(this.seconds, this.isRunning);
}

class TimeCountNotifier extends StateNotifier<Timestate> {
  TimeCountNotifier() : super(Timestate(0, false));
  Timer? timer;
  void start() {
    if (state.isRunning) return;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      state = Timestate(state.seconds! + 1, true);
    });
  }

  void stop() {
    timer?.cancel();
    state = Timestate(state.seconds, false);
  }

  void reset() {
    timer?.cancel();
    state = Timestate(0, false);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

final timeCountProvider = StateNotifierProvider<TimeCountNotifier, Timestate>((
  ref,
) {
  return TimeCountNotifier();
});
