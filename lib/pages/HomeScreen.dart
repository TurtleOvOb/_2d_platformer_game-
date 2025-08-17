import 'package:_2d_platformergame/pages/LevelScreen.dart';
import 'package:_2d_platformergame/pages/settingpage.dart';
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

                // 3. 菜单按钮和容器 - 使用图像容器
                Positioned(
                  top: height * 0.4,
                  left: width * 0.3,
                  right: width * 0.3,
                  child: ImageContainer(
                    imagePath:
                        'assets/images/containers/BackGround1.png', // 使用像素风格的背景图片

                    padding: EdgeInsets.all(width * 0.03),
                    imageFit: BoxFit.fill,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 使用新的ImageTextButton替换原来的按钮
                        ImageTextButton(
                          text: 'START',
                          imagePath:
                              'assets/images/buttons/Button1.png', // 你需要创建此图片
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LevelScreen(),
                              ),
                            );
                          },
                          animationType: ButtonAnimationType.bounce,
                          width: width * 0.2, // 增加宽度从0.3到0.4
                          height: height * 0.12, // 增加高度从0.1到0.12
                          imageFit: BoxFit.fill, // 添加imageFit参数，使图片填充整个按钮
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
                        SizedBox(height: height * 0.06),
                        // 使用新的ImageTextButton替换SETTINGS按钮
                        ImageTextButton(
                          text: 'SETTINGS',
                          imagePath:
                              'assets/images/buttons/Button1.png', // 需要创建此图片
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
                          animationType: ButtonAnimationType.pulse, // 使用脉冲动画效果
                          width: width * 0.4, // 增加宽度从0.3到0.4
                          height: height * 0.12, // 增加高度从0.1到0.12
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
                      ],
                    ),
                  ),
                ),

                // 左侧按钮
                Positioned(
                  top: height * 0.65, // 位置调高，从0.75改为0.65
                  left: width * 0.05, // 确保有一些左边距
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
                              fontSize: width * 0.04, // 稍微减小字体
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

                      SizedBox(height: height * 0.02), // 减小垂直间距
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: tapGithub,
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
                          InkWell(
                            onTap: tapYouTube,
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
                        ],
                      ),
                    ],
                  ),
                ),

                // Exit按钮 - 使用图片按钮
                Positioned(
                  top: height * 0.05,
                  right: width * 0.03,
                  child: ImageTextButton(
                    text: 'Exit',
                    imagePath: 'assets/images/buttons/Button1.png', // 需要创建此图片
                    onTap: tapexit,
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

                // 6. 版本号
                Positioned(
                  bottom: height * 0.05,
                  right: width * 0.05,
                  child: Text(
                    'v1.0',
                    style: TextStyle(
                      fontFamily: 'PixelMplus12-Regular',
                      color: Colors.black,
                      fontSize: width * 0.03,
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
