import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicSettingsPage extends StatefulWidget {
  const MusicSettingsPage({super.key});

  @override
  State<MusicSettingsPage> createState() => _MusicSettingsPageState();
}

class _MusicSettingsPageState extends State<MusicSettingsPage> {
  bool _isSoundEffectEnabled = true;
  double _soundEffectVolume = 1.0;
  bool _isBackgroundMusicEnabled = true;
  double _backgroundMusicVolume = 1.0;
  // 新增：记录当前选中的按钮索引（0: graphic, 1: music, 2: other）
  int _selectedTabIndex = 1;

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
              children: [
                // graphic 按钮
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 0;
                      // 可添加切换到 graphic 页面的逻辑
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, //改变按钮的点击区域与视觉大小一致
                  ),
                  child: Text(
                    'graphic',
                    style: GoogleFonts.lato(
                      fontSize: screenWidth * 0.06,
                      color: Colors.white,
                      decoration:
                          _selectedTabIndex == 0
                              ? TextDecoration.underline
                              : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.1),
                // music 按钮（当前选中）
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedTabIndex = 1;
                      // 可添加切换到 music 页面的逻辑
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'music',
                    style: GoogleFonts.lato(
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
                      // 可添加切换到 other 页面的逻辑
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'other',
                    style: GoogleFonts.lato(
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
                    style: GoogleFonts.lato(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _soundEffectVolume,
                      onChanged:
                          _isSoundEffectEnabled
                              ? (value) {
                                setState(() {
                                  _soundEffectVolume = value;
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
                    style: GoogleFonts.lato(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _backgroundMusicVolume,
                      onChanged:
                          _isBackgroundMusicEnabled
                              ? (value) {
                                setState(() {
                                  _backgroundMusicVolume = value;
                                });
                              }
                              : null,
                      activeColor: Colors.yellow,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ] else if (_selectedTabIndex == 0) ...[
              // 这里可以添加 graphic 设置的内容
              Text(
                'Graphic settings will be here',
                style: GoogleFonts.lato(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
              ),
            ] else if (_selectedTabIndex == 2) ...[
              // 这里可以添加 other 设置的内容
              Text(
                'Other settings will be here',
                style: GoogleFonts.lato(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                ),
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
                  style: GoogleFonts.lato(
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
