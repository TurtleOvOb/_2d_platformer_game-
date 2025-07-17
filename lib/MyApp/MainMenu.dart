import 'package:_2d_platformergame/level_editor/level_editor_ui.dart';
import 'package:_2d_platformergame/my_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('主菜单')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameWidget(game: MyGame()),
                  ),
                );
              },
              child: const Text('进入游戏'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LevelEditorScreen(),
                  ),
                );
              },
              child: const Text('编辑关卡'),
            ),
          ],
        ),
      ),
    );
  }
}
