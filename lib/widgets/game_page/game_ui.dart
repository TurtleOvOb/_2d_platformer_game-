import 'package:_2d_platformergame/pages/settingpage.dart';
import 'package:_2d_platformergame/providers/time_count.dart';
import 'package:_2d_platformergame/widgets/game_page/pause_dialog.dart';
import 'package:_2d_platformergame/widgets/game_page/task.dart';
import 'package:_2d_platformergame/widgets/game_page/timer_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class GameUi extends ConsumerStatefulWidget {
  const GameUi({super.key});

  @override
  ConsumerState<GameUi> createState() => _GameUiState();
}

class _GameUiState extends ConsumerState<GameUi> with TickerProviderStateMixin {
  late final Map<String, AnimationController> _controllers = {
    'library': AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    ),
    'pause': AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    ),
    'settings': AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    ),
  };
  late TimerCount timerCount;
  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildAnimatedButton({
    required String id,
    required IconData icon,
    required VoidCallback? onTap,
    required double size,
  }) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 0.8).animate(
        CurvedAnimation(parent: _controllers[id]!, curve: Curves.easeInOut),
      ),
      child: GestureDetector(
        onTapDown: (_) => _controllers[id]!.forward(),
        onTapUp: (_) {
          _controllers[id]!.reverse();
          onTap?.call(); // 在动画反向时调用 onTap
        },
        onTapCancel: () => _controllers[id]!.reverse(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 53, 53, 51),
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 53, 53, 51),
            size: size,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth, // 使用实际屏幕宽度
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: screenWidth * 0.01), // 减小起始间距
          Opacity(
            opacity: 0.5,
            child: Icon(
              Icons.hourglass_empty,
              color: const Color.fromARGB(255, 111, 111, 109),
              size: screenWidth * 0.04,
            ),
          ),
          SizedBox(width: screenWidth * 0.005), // 减小图标间距
          Opacity(
            opacity: 0.5,
            child: timerCount = TimerCount(size: screenWidth * 0.035),
          ),

          Spacer(flex: 2), // 调整Spacer的权重

          Opacity(
            opacity: 0.4,
            child: _buildAnimatedButton(
              id: 'library',
              icon: Icons.library_books,
              size: screenWidth * 0.035,
              onTap: () {
                ref.read(timeCountProvider.notifier).stop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: const Color.fromARGB(
                        255,
                        234,
                        148,
                        10,
                      ), // 背景改成橙色
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 圆角减少到 8
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Task(true, 'Task 1'),
                            Task(false, 'Task 2'),
                            Task(true, 'Task 3'),
                          ],
                        ),
                      ),
                    );
                  },
                ).then((value) {
                  ref.read(timeCountProvider.notifier).start();
                });
              },
            ),
          ),

          SizedBox(width: screenWidth * 0.01), // 减小图标间距

          Opacity(
            opacity: 0.4,
            child: _buildAnimatedButton(
              id: 'pause',
              icon: Icons.pause_rounded,
              size: screenWidth * 0.035,
              onTap: () {
                ref.read(timeCountProvider.notifier).stop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (dialogContext) => PauseDialog(
                        onResume: () {
                          Navigator.of(dialogContext).pop();
                          ref.read(timeCountProvider.notifier).start();
                        },
                        parentContext: context,
                      ),
                );
              },
            ),
          ),

          SizedBox(width: screenWidth * 0.01), // 减小图标间距

          Opacity(
            opacity: 0.4,
            child: _buildAnimatedButton(
              id: 'settings',
              icon: Icons.settings,
              size: screenWidth * 0.035,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MusicSettingsPage(),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: screenWidth * 0.01), // 减小结束间距
        ],
      ),
    );
  }
}
