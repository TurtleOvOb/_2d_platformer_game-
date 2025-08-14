import 'package:_2d_platformergame/pages/LevelScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:_2d_platformergame/providers/menu_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '/ontapthings/homepage/tapexit.dart';
import '/ontapthings/homepage/tapgithub.dart';
import '/ontapthings/homepage/tapyoutube.dart';
import 'package:flutter/material.dart';
import '../widgets/homepage/backgroundicon.dart';
import '../widgets/homepage/menubutton.dart';
import '../widgets/homepage/footerbutton.dart';
import '../widgets/homepage/selection_border.dart';
import 'package:_2d_platformergame/pages/LevelScreen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size; //获取屏幕尺寸
    final width = screenSize.width; //屏幕宽度
    final height = screenSize.height; //屏幕高度

    // 获取选择边框的位置和大小
    final menuState = ref.watch(menuProvider);
    final selectionPosition = menuState.selectionPosition;
    final selectionSize = menuState.selectionSize;

    return Scaffold(
      body: Container(
        color: const Color(0xFFFFC107),
        child: Stack(
          children: [
            // 1. 背景图案（最底层）
            createPatternBackground(width, height),

            // 2. 标题
            Positioned(
              top: height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Game Name',
                  style: TextStyle(
                    fontFamily: '851ShouShu',
                    color: Colors.white,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 3. 菜单按钮和容器
            Positioned(
              top: height * 0.4,
              left: width * 0.3,
              right: width * 0.3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.025),
                  color: const Color.fromARGB(255, 255, 142, 26),
                  border: Border.all(
                    color: Colors.white,
                    width: width * 0.008,
                    style: BorderStyle.solid,
                  ),
                ),
                padding: EdgeInsets.all(width * 0.03),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildMenuButton(
                      'START',
                      width,
                      height,
                      Icons.play_arrow,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LevelScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.06),
                    buildMenuButton(
                      'SETTINGS',
                      width,
                      height,
                      Icons.settings,
                      () {
                        print('Settings button clicked');
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 左侧按钮
            Positioned(
              top: height * 0.75,
              //  left: width * 0.005,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'ABOUT US',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w500,
                          //下划线
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          // 可选：调整下划线粗细，增强视觉效果
                          decorationThickness: 2,
                          // 可选：设置下划线样式（实线/虚线等）
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                      Icon(
                        Icons.arrow_downward,
                        size: width * 0.06,
                        color: Colors.white,
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.03),
                  Row(
                    children: [
                      buildFooterButton('GITHUB', width, Icons.code, tapGithub),
                      SizedBox(width: width * 0.02),
                      buildFooterButton(
                        'YOUTUBE',
                        width,
                        Icons.play_circle,
                        tapYouTube,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Exit按钮
            Positioned(
              top: height * 0.05,
              right: width * 0.03,
              child: InkWell(
                onTap: tapexit,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800),
                    borderRadius: BorderRadius.circular(width * 0.02),
                    border: Border.all(
                      color: Colors.white,
                      width: width * 0.006,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                      vertical: height * 0.005,
                    ),
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontFamily: '851ShouShu',
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 6. 版本号
            Positioned(
              bottom: height * 0.05,
              right: width * 0.05,
              child: Text(
                'v1.0',
                style: TextStyle(color: Colors.black, fontSize: width * 0.03),
              ),
            ),

            // 7. 菜单选择边框
            SelectionBorder(
              width: width,
              position: selectionPosition,
              size: selectionSize,
              borderRadius: width * 0.025,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCirc,
            ),
          ],
        ),
      ),
    );
  }
}
