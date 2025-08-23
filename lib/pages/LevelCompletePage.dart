import 'package:_2d_platformergame/widgets/homepage/image_text_button.dart';
import 'package:_2d_platformergame/utils/level_manager.dart';
import 'package:_2d_platformergame/Game/mission_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:_2d_platformergame/identfier/ldtk_parser.dart';

import 'package:_2d_platformergame/player/player.dart';

class LevelCompletePage extends ConsumerStatefulWidget {
  final int nowlevel;
  final int score;
  final Player? player;
  const LevelCompletePage({
    super.key,
    required this.nowlevel,
    required this.score,
    required this.player,
  });

  @override
  ConsumerState<LevelCompletePage> createState() => _LevelCompletePageState();
}

class _LevelCompletePageState extends ConsumerState<LevelCompletePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _floatAnim;
  // 移除未使用的变量

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _fadeAnim = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _floatAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _controller.forward(); // 只正向播放一次
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
  }

  int _calcStarCount() {
    // 获取当前关卡任务目标
    final mission = missionMap[widget.nowlevel];
    final player = widget.player;
    if (mission == null || player == null) return 0;
    final result = mission.check(player);
    int star = 0;
    if (result.timeOk) star++;
    if (result.deathOk) star++;
    if (result.collectOk) star++;
    return star;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 结算星星数并写入关卡管理器
    final starCount = _calcStarCount();
    LevelManager().updateLevel(widget.nowlevel, starCount);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.15,
        vertical: screenHeight * 0.15,
      ),
      child: ScaleTransition(
        scale: _scaleAnim,
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
              // ...烟花粒子特效已移除...
              // 内容区域
              Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: ScaleTransition(
                          scale: _floatAnim,
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
                      Center(
                        child: ScaleTransition(
                          scale: _floatAnim,
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
                      ImageTextButton(
                        text: 'Next Level',
                        imagePath: 'assets/images/buttons/Button1.png',
                        onTap: () async {
                          final nextLevelId = widget.nowlevel + 1;
                          final ldtkPath =
                              'assets/levels/Level_${nextLevelId}.ldtk';
                          int pxWid = 512, pxHei = 288;
                          try {
                            final parser = LdtkParser();
                            final result = await parser.parseLdtkLevelWithSize(
                              ldtkPath,
                            );
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
                                    levelId: nextLevelId,
                                    pxWid: pxWid,
                                    pxHei: pxHei,
                                  ),
                            ),
                          );
                        },
                        width: 180,
                        height: 60,
                        animationType: ButtonAnimationType.bounce,
                        textStyle: const TextStyle(
                          fontFamily: 'PixelMplus12-Regular',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // 返回主页按钮
                      ImageTextButton(
                        text: 'Home',
                        imagePath: 'assets/images/buttons/Button1.png',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        width: 180,
                        height: 60,
                        animationType: ButtonAnimationType.bounce,
                        textStyle: const TextStyle(
                          fontFamily: 'PixelMplus12-Regular',
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
