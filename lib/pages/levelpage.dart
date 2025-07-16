import 'package:_2d_platformergame/widgets/homepage/backgroundicon.dart';
import 'package:_2d_platformergame/widgets/levepage/categoryvutton.dart';
import 'package:_2d_platformergame/widgets/levepage/levelcard.dart';
import 'package:flutter/material.dart';

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
                width: width * 0.12,
                color: const Color(0xFFFF8F00),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildCategoryButton('I', width, height),
                    buildCategoryButton('II', width, height),
                    buildCategoryButton('III', width, height),
                    buildCategoryButton('VI', width, height),
                  ],
                ),
              ),
            ),
            // 关卡卡片区域
            Positioned(
              left: width * 0.1,
              top: 0,
              right: 0,
              bottom: 0,
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.all(width * 0.03),
                children: List.generate(12, (index) {
                  int levelNumber = index + 1; //关卡编号
                  bool isUnlocked = levelNumber <= 6; //是否解锁
                  return buildLevelCard(levelNumber, isUnlocked, width, height);
                }),
              ),
            ),
            // 返回按钮
            Positioned(
              bottom: height * 0.01,
              right: width * 0,
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
          ],
        ),
      ),
    );
  }

  // 构建背景图案

  // 构建关卡分类按钮

  // 构建关卡卡片
}
