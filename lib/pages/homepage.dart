import 'package:firsgame/ontapthings/homepage/tapexit.dart';
import 'package:firsgame/ontapthings/homepage/tapgithub.dart';
import 'package:firsgame/ontapthings/homepage/taplevels.dart';
import 'package:firsgame/ontapthings/homepage/tapstart.dart';
import 'package:firsgame/ontapthings/homepage/tapyoutube.dart';
import 'package:firsgame/ontapthings/homepage/tspsettings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/homepage/backgroundicon.dart';
import '../widgets/homepage/menubutton.dart';
import '../widgets/homepage/footerbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; //获取屏幕尺寸
    final width = screenSize.width; //屏幕宽度
    final height = screenSize.height; //屏幕高度

    return Scaffold(
      body: Container(
        color: const Color(0xFFFFC107),
        child: Stack(
          children: [
            // 使用Icon创建背景图案效果
            createPatternBackground(width, height),

            // 标题
            Positioned(
              top: height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'GAME NAME',
                  style: GoogleFonts.permanentMarker(
                    // 使用谷歌字体
                    color: Colors.white,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 菜单按钮
            Positioned(
              top: height * 0.4,
              left: width * 0.3,
              right: width * 0.3,
              child: Container(
                decoration: BoxDecoration(
                  //让四个顶点圆润一点
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(155, 219, 108, 4),
                  border: Border.all(
                    color: Colors.white, // 边框颜色：白色
                    width: width * 0.005, // 边框宽度：用屏幕宽度比例适配，避免固定值在不同设备上粗细不一
                    style: BorderStyle.solid, // 边框样式：实线（默认，可省略）
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
                      tapStart,
                    ),
                    SizedBox(height: height * 0.03),
                    buildMenuButton(
                      'LEVELS',
                      width,
                      height,
                      Icons.menu,
                      tapLevels,
                    ),
                    SizedBox(height: height * 0.03),
                    buildMenuButton(
                      'SETTINGS',
                      width,
                      height,
                      Icons.settings,
                      tapSettings,
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
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
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
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 版本号
            Positioned(
              bottom: height * 0.05,
              right: width * 0.05,
              child: Text(
                'v1.0',
                style: TextStyle(color: Colors.black, fontSize: width * 0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
