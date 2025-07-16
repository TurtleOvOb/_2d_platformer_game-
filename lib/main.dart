import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'my_game.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatefulWidget {
  @override
  _GameAppState createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  final MyGame game = MyGame();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 确保在组件初始化后请求焦点
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: game.onKeyEvent,
          child: GameWidget(game: game),
        ),
      ),
    );
  }
}
