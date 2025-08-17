import 'package:_2d_platformergame/widgets/buildgradientbut.dart';
import 'package:flutter/material.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:_2d_platformergame/identfier/ldtk_parser.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.15, // 水平内边距
        vertical: screenHeight * 0.15, // 垂直内边距
      ),
      child: Container(
        width: screenWidth * 0.6, // 限制最大宽度
        constraints: BoxConstraints(
          maxWidth: 400, // 设置绝对最大宽度
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Colors.red.shade900, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          // 添加白色描边
          border: Border.all(
            color: Colors.white,
            width: 3.0, // 描边宽度
          ),
          // 添加阴影效果使描边更突出
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 内容区域
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 顶部闪烁文字
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: const Text(
                        'Game Over',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
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
                  ),
                  const SizedBox(height: 20),
                  // 中间提示文字动画
                  Center(
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: const Text(
                          'Try Again?',
                          textAlign: TextAlign.center,
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
                  ),
                  const SizedBox(height: 40),
                  // 按钮区域
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 重试按钮
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GradientButton(
                            text: 'Restart',
                            gradientColors: [
                              const Color.fromARGB(255, 228, 159, 159),
                              Colors.deepOrange,
                            ],
                            onTap: () async {
                              // 获取关卡尺寸
                              final ldtkPath =
                                  'assets/levels/Level_${widget.nowlevel}.ldtk';
                              int pxWid = 512, pxHei = 288; // 默认尺寸
                              try {
                                final parser = LdtkParser();
                                final result = await parser
                                    .parseLdtkLevelWithSize(ldtkPath);
                                pxWid = result.$2;
                                pxHei = result.$3;
                              } catch (e) {
                                print('读取关卡尺寸失败，使用默认值: $e');
                                // 读取失败用默认值
                              }

                              if (!mounted) return;

                              // 先关闭对话框
                              Navigator.of(context).pop();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => GameScreen(
                                        levelId: widget.nowlevel,
                                        pxWid: pxWid,
                                        pxHei: pxHei,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // 退出按钮
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GradientButton(
                            text: 'Exit',
                            gradientColors: [
                              Colors.purple,
                              const Color.fromARGB(255, 155, 137, 205),
                            ],
                            onTap: () {
                              // 先关闭对话框
                              Navigator.of(context).pop();

                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
