import 'package:_2d_platformergame/widgets/buildgradientbut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:_2d_platformergame/identfier/ldtk_parser.dart';
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
  // 移除未使用的变量

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

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.15, // 增加水平内边距使容器变窄
        vertical: screenHeight * 0.15, // 增加垂直内边距
      ),
      child: Container(
        width: screenWidth * 0.6, // 限制最大宽度
        constraints: BoxConstraints(
          maxWidth: 400, // 设置绝对最大宽度
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.orange,
          // 白色描边
          border: Border.all(
            color: Colors.white,
            width: 3.0, // 描边宽度
          ),
          // 阴影效果使描边更突出
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 烟花粒子
            ...List.generate(
              25, // 进一步减少粒子数量以适应更小的对话框
              (index) => _buildFirework(
                top: Random().nextDouble() * 150, // 固定高度范围
                left: Random().nextDouble() * 300, // 固定宽度范围
              ),
            ),

            // 内容区域
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 通关文字动画
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: const Text(
                          'Level Completed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'PixelMplus12-Regular',
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
                  ),
                  const SizedBox(height: 15),
                  // 分数展示
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Text(
                          'Score: ${widget.score}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'PixelMplus12-Regular',
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
                  ),
                  const SizedBox(height: 25),

                  // 下一关按钮
                  GradientButton(
                    text: 'Next Level',
                    gradientColors: [Colors.green, Colors.lightGreenAccent],
                    onTap: () async {
                      // 获取下一关的关卡尺寸
                      final nextLevelId = widget.nowlevel + 1;
                      final ldtkPath =
                          'assets/levels/Level_${nextLevelId}.ldtk';
                      int pxWid = 512, pxHei = 288; // 默认尺寸
                      try {
                        final parser = LdtkParser();
                        final result = await parser.parseLdtkLevelWithSize(
                          ldtkPath,
                        );
                        pxWid = result.$2;
                        pxHei = result.$3;
                      } catch (e) {
                        // 读取失败用默认值
                      }

                      if (!mounted) return;

                      // 先关闭对话框，再导航到下一关
                      Navigator.of(context).pop();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => GameScreen(
                                levelId: nextLevelId,
                                pxWid: pxWid,
                                pxHei: pxHei,
                              ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // 返回主页按钮
                  GradientButton(
                    text: 'Home',
                    gradientColors: [Colors.purple, Colors.deepPurpleAccent],
                    onTap: () {
                      // 先关闭对话框，再导航到主页
                      Navigator.of(context).pop();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
