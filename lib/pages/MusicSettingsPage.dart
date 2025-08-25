import 'package:_2d_platformergame/audiomanage.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

double soundEffectVolume = 1.0;

class MusicSettingsPage extends StatefulWidget {
  const MusicSettingsPage({super.key});

  @override
  State<MusicSettingsPage> createState() => MusicSettingsPageState();
}

class MusicSettingsPageState extends State<MusicSettingsPage> {
  bool _isSoundEffectEnabled = true;

  bool _isBackgroundMusicEnabled = true;
  static double backgroundMusicVolume = 1.0;
  // 新增：记录当前选中的按钮索引（0: graphic, 1: music, 2: other）
  int _selectedTabIndex = 1;
  bool isOn = true;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.orange,
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部的按钮 Row（替代原本文本）
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // music 按钮（当前选中）
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 1;
                      AudioManage().playclick();
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'music',
                    style: TextStyle(
                      fontFamily: 'PixelMplus12-Regular',
                      fontSize: screenWidth * 0.06,
                      color: Colors.white,
                      decoration:
                          _selectedTabIndex == 1
                              ? TextDecoration.underline
                              : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.1),
                // other 按钮
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 2;
                      AudioManage().playclick();
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'other',
                    style: TextStyle(
                      fontFamily: 'PixelMplus12-Regular',
                      fontSize: screenWidth * 0.06,
                      color: Colors.white,
                      decoration:
                          _selectedTabIndex == 2
                              ? TextDecoration.underline
                              : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            // 根据 _selectedTabIndex 显示不同的设置内容
            if (_selectedTabIndex == 1) ...[
              // 音效设置行（不变）
              Row(
                children: [
                  Checkbox(
                    value: _isSoundEffectEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isSoundEffectEnabled = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'sound effect',
                    style: TextStyle(
                      fontFamily: 'PixelMplus12-Regular',
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: soundEffectVolume,
                      onChanged:
                          _isSoundEffectEnabled
                              ? (value) {
                                setState(() {
                                  soundEffectVolume = value;
                                  AudioManage.volume = value;
                                });
                              }
                              : null,
                      activeColor: Colors.yellow,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // 背景音乐设置行（不变）
              Row(
                children: [
                  Checkbox(
                    value: _isBackgroundMusicEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isBackgroundMusicEnabled = value ?? false;
                      });
                    },
                  ),
                  Text(
                    'background music',
                    style: TextStyle(
                      fontFamily: 'PixelMplus12-Regular',
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: backgroundMusicVolume,
                      onChanged:
                          _isBackgroundMusicEnabled
                              ? (value) {
                                setState(() {
                                  backgroundMusicVolume = value;
                                  FlameAudio.bgm.audioPlayer.setVolume(
                                    backgroundMusicVolume,
                                  );
                                });
                              }
                              : null,
                      activeColor: Colors.yellow,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ] else if (_selectedTabIndex == 2) ...[
              // 这里可以添加 other 设置的内容
              Column(
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // 改成 center，避免超高
                    children: [
                      SizedBox(width: screenWidth * 0.05),
                      Text(
                        'Language',
                        style: TextStyle(
                          fontFamily: 'PixelMplus12-Regular',
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          value: '2',
                          items: const [
                            DropdownMenuItem(value: '1', child: Text('中文')),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('English'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            // 处理选中事件
                            //print('选择了: $newValue');
                          },
                          decoration: InputDecoration(
                            // labelText: '选择语言', // 可选标题
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), // 圆角
                              borderSide: const BorderSide(
                                color: Colors.white, // 边框颜色
                                width: 2, // 边框宽度
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'PixelMplus12-Regular',
                            color: Colors.white,
                            fontSize: screenWidth * 0.02,
                          ),
                          dropdownColor: const Color.fromARGB(
                            255,
                            136,
                            132,
                            132,
                          ), // 下拉列表背景色
                        ),
                      ),

                      SizedBox(width: screenWidth * 0.05),
                    ],
                  ),
                  SwitchListTile(
                    title: Text(
                      'Particle Effect',
                      style: TextStyle(
                        fontFamily: 'PixelMplus12-Regular',
                        fontSize: screenWidth * 0.045,
                        color: Colors.white,
                      ),
                    ),
                    //subtitle: const Text('打开后可以收到消息提醒'),
                    value: isOn,
                    onChanged: (bool value) {
                      setState(() {
                        isOn = value;
                      });
                    },
                  ),
                ],
              ),
            ],

            const Spacer(),
            // 退出按钮（修改为 TextButton）
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  // 可添加退出逻辑
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ), //按钮的形状和圆角
                  padding: EdgeInsets.all(screenWidth * 0.02),
                ),
                child: Text(
                  'Exit',
                  style: TextStyle(
                    fontFamily: 'PixelMplus12-Regular',
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
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
