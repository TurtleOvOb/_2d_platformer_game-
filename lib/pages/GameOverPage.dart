import 'package:_2d_platformergame/widgets/buildgradientbut.dart';
import 'package:flutter/material.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameOverPage extends ConsumerStatefulWidget {
  final int nowlevel;
  const GameOverPage({super.key, required this.nowlevel});

  @override
  ConsumerState<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends ConsumerState<GameOverPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  bool _restartPressed = false;
  bool _exitPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _fadeAnim = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
    _scaleAnim = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget _buildGradientButton({
  //   required String text,
  //   required List<Color> gradientColors,
  //   required bool pressed,
  //   required VoidCallback onTap,
  //   required void Function(bool) onPressedStateChanged,
  // }) {
  //   return GestureDetector(
  //     onTapDown: (_) => setState(() => onPressedStateChanged(true)),
  //     onTapUp: (_) {
  //       setState(() => onPressedStateChanged(false));
  //       onTap();
  //     },
  //     onTapCancel: () => setState(() => onPressedStateChanged(false)),
  //     child: Transform.scale(
  //       scale: pressed ? 0.9 : 1.0,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors: gradientColors,
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //           ),
  //           borderRadius: BorderRadius.circular(20),
  //           boxShadow: [
  //             BoxShadow(
  //               color: gradientColors.last.withOpacity(0.4),
  //               blurRadius: 8,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //           child: Text(
  //             text,
  //             style: const TextStyle(
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //               shadows: [
  //                 Shadow(
  //                   offset: Offset(1, 1),
  //                   blurRadius: 4,
  //                   color: Colors.black38,
  //                 ),
  //               ],
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 顶部闪烁文字
                FadeTransition(
                  opacity: _fadeAnim,
                  child: const Text(
                    'Game Over',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      shadows: [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 5,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 中间提示文字动画
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: const Text(
                      'Try Again?',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 4,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // 重试按钮
                GradientButton(
                  text: 'Restart',
                  gradientColors: [
                    const Color.fromARGB(255, 228, 159, 159),
                    Colors.deepOrange,
                  ],

                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProviderScope(
                              child: GameScreen(levelId: widget.nowlevel),
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // 退出按钮
                GradientButton(
                  text: 'Exit',
                  gradientColors: [
                    Colors.purple,
                    const Color.fromARGB(255, 155, 137, 205),
                  ],

                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder:
                            (context) => ProviderScope(child: HomeScreen()),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
