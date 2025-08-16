import 'package:_2d_platformergame/widgets/buildgradientbut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'dart:math';

class LevelCompletePage extends ConsumerStatefulWidget {
  final int nowlevel;
  final int score;
  const LevelCompletePage({
    super.key,
    required this.nowlevel,
    required this.score,
  });

  @override
  ConsumerState<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends ConsumerState<LevelCompletePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  bool _nextPressed = false;
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

  // // 模拟简单的烟花粒子效果
  Widget _buildFirework({required double top, required double left}) {
    final random = Random();
    return Positioned(
      top: top,
      left: left,
      child: Opacity(
        opacity: random.nextDouble(),
        child: Container(
          width: 5 + random.nextDouble() * 5,
          height: 5 + random.nextDouble() * 5,
          decoration: BoxDecoration(
            color: Colors.primaries[random.nextInt(Colors.primaries.length)],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // 烟花粒子
          ...List.generate(
            50,
            (index) => _buildFirework(
              top: Random().nextDouble() * screenHeight,
              left: Random().nextDouble() * screenWidth,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 通关文字动画
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: const Text(
                      'Level Completed!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent,
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
                ),
                const SizedBox(height: 20),
                // 分数展示
                ScaleTransition(
                  scale: _scaleAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      'Score: ${widget.score}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                // 下一关按钮
                GradientButton(
                  text: 'Next Level',
                  gradientColors: [Colors.green, Colors.lightGreenAccent],
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ProviderScope(
                              child: GameScreen(levelId: widget.nowlevel + 1),
                            ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                // 返回主页按钮
                GradientButton(
                  text: 'Home',
                  gradientColors: [Colors.purple, Colors.deepPurpleAccent],

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
