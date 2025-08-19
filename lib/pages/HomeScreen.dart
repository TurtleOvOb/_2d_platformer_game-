import 'package:_2d_platformergame/Pages/MusicSettingsPage.dart';
import 'package:_2d_platformergame/pages/LevelScreen.dart';
import 'package:_2d_platformergame/Animation/animated_entry_widget.dart';
import 'package:_2d_platformergame/Animation/page_transitions.dart';
import 'package:_2d_platformergame/Animation/synchronized_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/ontapthings/homepage/tapexit.dart';
import '/ontapthings/homepage/tapgithub.dart';
import '/ontapthings/homepage/tapyoutube.dart';
import 'package:flutter/material.dart';
import '../widgets/homepage/backgroundicon.dart';
import '../widgets/homepage/image_text_button.dart';
import '../widgets/homepage/image_container.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size; //获取屏幕尺寸
    final width = screenSize.width; //屏幕宽度
    final height = screenSize.height; //屏幕高度

    return Stack(
      children: [
        // 原有 Scaffold
        Scaffold(
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
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromTop,
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: Center(
                      child: Text(
                        'Game Name',
                        style: TextStyle(
                          fontFamily: 'PixelMplus12-Regular',
                          color: Colors.white,
                          fontSize: width * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // 3. 菜单按钮和容器 - 使用图像容器
                Positioned(
                  top: height * 0.4,
                  left: width * 0.3,
                  right: width * 0.3,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromBottom,
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: ImageContainer(
                      imagePath: 'assets/images/containers/BackGround1.png',
                      padding: EdgeInsets.all(width * 0.03),
                      imageFit: BoxFit.fill,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedEntryWidget(
                            animationType: EntryAnimationType.slideFromBottom,
                            duration: const Duration(milliseconds: 900),
                            delay: const Duration(milliseconds: 100),
                            child: ImageTextButton(
                              text: 'START',
                              imagePath: 'assets/images/buttons/Button1.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    const LevelScreen(),
                                    type: PageTransitionType.slideRight,
                                  ),
                                );
                              },
                              animationType: ButtonAnimationType.bounce,
                              width: width * 0.2,
                              height: height * 0.12,
                              imageFit: BoxFit.fill,
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: width * 0.04,
                              ),
                              textStyle: TextStyle(
                                fontFamily: 'PixelMplus12-Regular',
                                color: Colors.white,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.06),
                          AnimatedEntryWidget(
                            animationType: EntryAnimationType.slideFromBottom,
                            duration: const Duration(milliseconds: 900),
                            delay: const Duration(milliseconds: 100),
                            child: ImageTextButton(
                              text: 'SETTINGS',
                              imagePath: 'assets/images/buttons/Button1.png',
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (dialogContext) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.08,
                                        vertical: height * 0.08,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          width * 0.02,
                                        ),
                                        child: const MusicSettingsPage(),
                                      ),
                                    );
                                  },
                                );
                              },
                              animationType: ButtonAnimationType.pulse,
                              width: width * 0.4,
                              height: height * 0.12,
                              icon: Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: width * 0.04,
                              ),
                              textStyle: TextStyle(
                                fontFamily: 'PixelMplus12-Regular',
                                color: Colors.white,
                                fontSize: width * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 左侧按钮
                Positioned(
                  top: height * 0.65,
                  left: width * 0.05,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromLeft,
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ABOUT US',
                              style: TextStyle(
                                fontFamily: 'PixelMplus12-Regular',
                                color: Colors.white,
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: tapGithub,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.code,
                                      color: Colors.white,
                                      size: width * 0.04,
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Text(
                                      'GITHUB',
                                      style: TextStyle(
                                        fontFamily: 'PixelMplus12-Regular',
                                        color: Colors.white,
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: tapYouTube,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle,
                                      color: Colors.white,
                                      size: width * 0.04,
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Text(
                                      'YOUTUBE',
                                      style: TextStyle(
                                        fontFamily: 'PixelMplus12-Regular',
                                        color: Colors.white,
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Exit按钮 - 使用图片按钮
                Positioned(
                  top: height * 0.05,
                  right: width * 0.03,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.rotateIn,
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: ImageTextButton(
                      text: 'Exit',
                      imagePath: 'assets/images/buttons/Button1.png',
                      onTap: tapexit,
                      animationType: ButtonAnimationType.shake,
                      width: width * 0.1,
                      height: height * 0.06,
                      textStyle: TextStyle(
                        fontFamily: 'PixelMplus12-Regular',
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: width * 0.03,
                      ),
                    ),
                  ),
                ),

                // 6. 版本号
                Positioned(
                  bottom: height * 0.05,
                  right: width * 0.05,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.fadeIn,
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'v1.0',
                      style: TextStyle(
                        fontFamily: 'PixelMplus12-Regular',
                        color: Colors.black,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
