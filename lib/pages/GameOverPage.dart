import 'package:_2d_platformergame/utils/audiomanage.dart';
import 'package:_2d_platformergame/widgets/homepage/image_text_button.dart';
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
        horizontal: screenWidth * 0.15,
        vertical: screenHeight * 0.15,
      ),
      child: Container(
        width: screenWidth * 0.6,
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.transparent,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 背景图片
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/containers/BackGround1.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
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
                          fontFamily: 'PixelMplus12-Regular',
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
                            fontSize: 28,
                            fontFamily: 'PixelMplus12-Regular',
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
                          child: ImageTextButton(
                            text: 'Restart',
                            imagePath: 'assets/images/buttons/Button1.png',
                            onTap: () async {
                              AudioManage().playclick();
                              final ldtkPath =
                                  'assets/levels/Level_${widget.nowlevel}.ldtk';
                              int pxWid = 512, pxHei = 288;
                              try {
                                final parser = LdtkParser();
                                final result = await parser
                                    .parseLdtkLevelWithSize(ldtkPath);
                                pxWid = result.$2;
                                pxHei = result.$3;
                              } catch (e) {}
                              if (!mounted) return;
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
                            width: 150,
                            height: 50,
                            animationType: ButtonAnimationType.bounce,
                            textStyle: const TextStyle(
                              fontFamily: 'PixelMplus12-Regular',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 退出按钮
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageTextButton(
                            text: 'Exit',
                            imagePath: 'assets/images/buttons/Button1.png',
                            onTap: () {
                              AudioManage().playclick();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            width: 150,
                            height: 50,
                            animationType: ButtonAnimationType.bounce,
                            textStyle: const TextStyle(
                              fontFamily: 'PixelMplus12-Regular',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
