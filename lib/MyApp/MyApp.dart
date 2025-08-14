import 'package:_2d_platformergame/Game/Game_Screen.dart';
import 'package:_2d_platformergame/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:_2d_platformergame/pages/LevelScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '游戏与关卡编辑器',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
