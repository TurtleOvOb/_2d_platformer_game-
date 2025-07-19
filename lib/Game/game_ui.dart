// 新增：暂停覆盖页面组件

import 'package:_2d_platformergame/pages/homepage.dart';
import 'game_logic.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PauseOverlay extends StatelessWidget {
  final MyGame game;
  final VoidCallback onReturnToMain;

  const PauseOverlay({
    Key? key,
    required this.game,
    required this.onReturnToMain,
  }) : super(key: key);

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
  final MyGame game = MyGame();

  GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {
                game.pauseGame();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => PauseOverlay(
                        game: game,
                        onReturnToMain: () {
                          // 使用 pushReplacement 跳转到主菜单
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
