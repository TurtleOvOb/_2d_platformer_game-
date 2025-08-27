import 'dart:ui';
import 'package:_2d_platformergame/Animation/page_transitions.dart';
import 'package:_2d_platformergame/identfier/ldtk_parser.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/widgets/levepage/categoryvutton.dart';
import 'package:_2d_platformergame/widgets/levepage/animated_levelcard.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:_2d_platformergame/utils/level_manager.dart';
import 'package:_2d_platformergame/utils/MovingBackground.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  bool _showTransitionMask = false;
  double _maskOpacity = 0.0;
  bool _loading = true;
  final int _totalLevels = 16;

  @override
  void initState() {
    super.initState();
    // LevelManager().clearAllProgress(_totalLevels).then((_) {
    //   _initLevels();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 每次页面显示时刷新关卡数据
    _resetCurrentLevelDeathCount();
    _initLevels();
  }

  void _resetCurrentLevelDeathCount() async {
    // 获取所有关卡，重置每一关的死亡次数（如只需重置当前关卡可根据实际需求调整）
    final manager = LevelManager();
    await manager.loadLevels(_totalLevels);
    for (var level in manager.allLevels) {
      if (level.deathCount != 0) {
        manager.updateLevel(level.levelId, level.starCount, deathCount: 0);
      }
    }
  }

  Future<void> _initLevels() async {
    await LevelManager().loadLevels(_totalLevels);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          MovingBackground(
            imagePath: 'assets/images/containers/BackGround3.png',
            width: width,
            height: height,
            speed: 30,
            scale: 1.2,
          ),
          if (_showTransitionMask)
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 18),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'PixelMplus12-Regular',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // 左侧关卡分类栏
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: width * 0.14, // 增加菜单栏宽度
              color: const Color(0xFFFF8F00),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCategoryButton('I', width, height),
                    buildCategoryButton('II', width, height),
                    buildCategoryButton('III', width, height),
                    buildCategoryButton('VI', width, height),
                  ],
                ),
              ),
            ),
          ),
          // 关卡卡片区域
          Positioned(
            left: width * 0.14, // 更新左侧位置，与菜单栏宽度对齐
            top: 0,
            right: 0,
            bottom: 0,
            child: GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(width * 0.03),
              children: List.generate(_totalLevels, (index) {
                final levelData = LevelManager().getLevel(index);
                return AnimatedLevelCard(
                  levelNumber: levelData.levelId + 1,
                  isUnlocked: levelData.isUnlocked,
                  starCount: levelData.starCount, // 这里传入星星数
                  width: width,
                  height: height,
                  onTap:
                      levelData.isUnlocked
                          ? () async {
                            setState(() {
                              _showTransitionMask = true;
                              _maskOpacity = 0.0;
                            });
                            await Future.delayed(
                              const Duration(milliseconds: 10),
                            );
                            setState(() => _maskOpacity = 1.0);
                            final ldtkPath =
                                'assets/levels/Level_${levelData.levelId}.ldtk';
                            int pxWid = 512, pxHei = 288;
                            try {
                              final parser = LdtkParser();
                              final result = await parser
                                  .parseLdtkLevelWithSize(ldtkPath);
                              pxWid = result.$2;
                              pxHei = result.$3;
                            } catch (e) {
                              // 读取失败用默认
                            }
                            await Future.delayed(
                              const Duration(milliseconds: 350),
                            );
                            if (!mounted) return;
                            setState(() => _maskOpacity = 0.0);
                            await Future.delayed(
                              const Duration(milliseconds: 200),
                            );
                            setState(() => _showTransitionMask = false);
                            Navigator.push(
                              context,
                              createRoute(
                                GameScreen(
                                  levelId: levelData.levelId,
                                  pxWid: pxWid,
                                  pxHei: pxHei,
                                ),
                                type: PageTransitionType.fade,
                              ),
                            );
                          }
                          : null,
                );
              }),
            ),
          ),
          // 返回按钮
          Positioned(
            bottom: height * 0.01,
            right: width * 0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  createRoute(
                    const HomeScreen(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/buttons/Button1.png',
                    width: width * 0.2,
                    height: height * 0.08,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PixelMplus12-Regular',
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
