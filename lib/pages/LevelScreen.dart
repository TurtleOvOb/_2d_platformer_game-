import 'package:_2d_platformergame/identfier/ldtk_parser.dart';
import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/widgets/homepage/backgroundicon.dart';
import 'package:_2d_platformergame/widgets/levepage/categoryvutton.dart';
import 'package:_2d_platformergame/widgets/levepage/animated_levelcard.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFFC107),
        child: Stack(
          children: [
            // 背景图案，这里简单复用之前的菱形图案逻辑
            createPatternBackground(width, height),
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
                children: List.generate(16, (index) {
                  int levelNumber = index + 1; //关卡编号
                  bool isUnlocked = levelNumber <= 6; //是否解锁
                  return AnimatedLevelCard(
                    levelNumber: levelNumber,
                    isUnlocked: isUnlocked,
                    width: width,
                    height: height,
                    onTap:
                        isUnlocked
                            ? () async {
                              final ldtkPath =
                                  'assets/levels/Level_${levelNumber - 1}.ldtk';
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ProviderScope(
                                        child: GameScreen(
                                          levelId: levelNumber,
                                          pxWid: pxWid,
                                          pxHei: pxHei,
                                        ),
                                      ),
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
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ProviderScope(child: const HomeScreen()),
                    ),
                    (route) => false, // 清除所有路由历史
                  );
                },
                child: Container(
                  width: width * 0.2,
                  height: height * 0.08,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8F00),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: width * 0.06,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
