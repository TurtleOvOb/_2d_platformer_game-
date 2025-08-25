import 'package:_2d_platformergame/audiomanage.dart';
import 'package:flutter/material.dart';
import '../Game/My_Game.dart';

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
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '游戏暂停',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                backgroundColor: Colors.amber,
              ),
              onPressed: () {
                AudioManage().playclick();
                Navigator.of(context).pop(); // 关闭暂停对话框
                game.resumeGame();
              },
              child: const Text('继续游戏', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                AudioManage().playclick();
                Navigator.of(context).pop(); // 关闭暂停对话框
                onReturnToMain(); // 返回主菜单
              },
              child: const Text('返回主菜单', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
