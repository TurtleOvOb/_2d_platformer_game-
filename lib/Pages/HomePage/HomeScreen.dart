import 'package:_2d_platformergame/widgets/levepage/LevelScreen.dart';
import 'package:_2d_platformergame/widgets/game_page/SettingPage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'backgroundicon.dart';
import '../../utils/BuildButton/Image_Text_Button.dart';
import 'image_container.dart';
import '../../AnimationWidget/animated_entry_widget.dart';
import '../../utils/page_transitions.dart';

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

                // 2. 标题（从顶部滑入）- 同步动画
                Positioned(
                  top: height * 0.05,
                  left: 0,
                  right: 0,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromTop,
                    duration: const Duration(milliseconds: 1000),
                    delay: const Duration(milliseconds: 100), // 统一的短延迟
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

                Positioned(
                  top: height * 0.4,
                  left: width * 0.3,
                  right: width * 0.3,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromBottom,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 100), // 统一的短延迟
                    child: ImageContainer(
                      imagePath: 'assets/images/containers/BackGround1.png',
                      padding: EdgeInsets.all(width * 0.03),
                      imageFit: BoxFit.fill,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 使用新的ImageTextButton替换原来的按钮 - 同步入场动画（弹跳效果）
                          AnimatedEntryWidget(
                            animationType: EntryAnimationType.bounceIn,
                            delay: const Duration(milliseconds: 200), // 略微延迟
                            child: ImageTextButton(
                              text: 'START',
                              imagePath:
                                  'assets/images/buttons/Button1.png', // 你需要创建此图片
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    const LevelScreen(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
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
                            animationType: EntryAnimationType.scaleIn,
                            delay: const Duration(milliseconds: 200),
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
                              animationType:
                                  ButtonAnimationType.pulse, // 使用脉冲动画效果
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

                // 左侧按钮（从左侧滑入）- 同步动画
                Positioned(
                  top: height * 0.65,
                  left: width * 0.05,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.slideFromLeft,
                    duration: const Duration(milliseconds: 800),
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
                            // GitHub按钮（淡入动画）- 同步动画
                            AnimatedEntryWidget(
                              animationType: EntryAnimationType.fadeIn,
                              delay: const Duration(milliseconds: 200),
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ), // 增加点击区域
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
                            ),
                            // YouTube按钮（淡入动画）- 同步动画
                            AnimatedEntryWidget(
                              animationType: EntryAnimationType.fadeIn,
                              delay: const Duration(milliseconds: 200),
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ), // 增加点击区域
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Exit按钮 - 使用图片按钮（从顶部滑入）- 同步动画
                Positioned(
                  top: height * 0.05,
                  right: width * 0.03,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.rotateIn,
                    delay: const Duration(milliseconds: 100),
                    child: ImageTextButton(
                      text: 'Exit',
                      imagePath: 'assets/images/buttons/Button1.png', // 需要创建此图片
                      onTap: () {},
                      animationType: ButtonAnimationType.shake, // 使用抖动动画效果
                      width: width * 0.1, // 较小的宽度
                      height: height * 0.06, // 较小的高度
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

                // 6. 版本号（淡入效果）- 同步动画
                Positioned(
                  bottom: height * 0.05,
                  right: width * 0.05,
                  child: AnimatedEntryWidget(
                    animationType: EntryAnimationType.fadeIn,
                    delay: const Duration(milliseconds: 100), // 统一的短延迟
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
