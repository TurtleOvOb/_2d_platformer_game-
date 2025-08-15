// 新增：暂停覆盖页面组件
import 'package:_2d_platformergame/widgets/game_page/game_ui.dart';
import 'My_Game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PauseOverlay extends StatelessWidget {
  final MyGame game;
  final VoidCallback onReturnToMain;

  const PauseOverlay({
    super.key,
    required this.game,
    required this.onReturnToMain,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                game.resumeGame();
                Navigator.pop(context);
              },
              child: const Text('继续游戏'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // 调用 onReturnToMain 方法前先关闭暂停对话框
                Navigator.pop(context);
                onReturnToMain();
              },
              child: const Text('返回主页面'),
            ),
          ],
        ),
      ),
    );
  }
}

// 新增：游戏界面组件

class GameScreen extends StatelessWidget {
  final int? levelId;
  final int pxWid;
  final int pxHei;
  late final MyGame game;

  GameScreen({
    super.key,
    this.levelId,
    required this.pxWid,
    required this.pxHei,
  }) : game = MyGame(levelId: levelId, pxWid: pxWid, pxHei: pxHei);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover, // 裁剪并铺满
              child: SizedBox(
                width: 512,
                height: 288,
                child: GameWidget(game: game),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: GameUi()),
          ),
        ],
      ),
    );
  }
}
