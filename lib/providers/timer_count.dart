import 'package:_2d_platformergame/providers/time_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerCount extends ConsumerStatefulWidget {
  final double? size;
  TimerCount({super.key, required this.size});

  @override
  ConsumerState<TimerCount> createState() => _TimerCountState();
}

class _TimerCountState extends ConsumerState<TimerCount> {
  @override
  void initState() {
    super.initState();
    ref.read(timeCountProvider.notifier).start();
  }

  @override
  Widget build(BuildContext context) {
    final timeCount = ref.watch(timeCountProvider);
    int seconds = timeCount.seconds ?? 0;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return Text(
      '$m:$s',
      style: TextStyle(
        //取消下划线
        decoration: TextDecoration.none,
        fontSize: widget.size,
        color: const Color.fromARGB(255, 142, 131, 131),
      ),
    );
  }
}
