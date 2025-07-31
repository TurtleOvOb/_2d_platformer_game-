import 'package:_2d_platformergame/player/player.dart';
import '../identfier/ldtk_parser.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, KeyboardEvents {
  late Player player;
  final Set<LogicalKeyboardKey> pressedKeys = {};

  bool isPaused = false; // 新增：暂停状态

  MyGame()
    : super(
        camera: CameraComponent.withFixedResolution(width: 512, height: 288),
      );

  @override
  Color backgroundColor() => const Color(0xFFFFC300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    //debugMode = true;
    initial();
  }

  Future<void> initial() async {
    world.add(player = Player(spawnPosition: Vector2(16, 144)));

    // 设置相机初始位置，使玩家位于屏幕左中边缘
    camera.viewfinder.position = Vector2(144, 144);
    camera.follow(player);
    await BrickGenerator();
  }

  Future<void> BrickGenerator() async {
    final parser = LdtkParser();
    final bricks = await parser.parseLdtkLevel('assets/levels/Level_0.ldtk');
    for (var brick in bricks) {
      world.add(brick);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!isPaused) {
      // 仅在非暂停状态下处理点击事件
      player.jump();
    }
  }

  @override
  void update(double dt) {
    if (!isPaused) {
      // 仅在非暂停状态下更新游戏
      super.update(dt);
      if (pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
        player.moveLeft();
      } else if (pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
        player.moveRight();
      } else {
        player.stopHorizontal();
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!isPaused) {
      // 仅在非暂停状态下处理键盘事件
      if (event is KeyDownEvent) {
        pressedKeys.add(event.logicalKey);
        if (event.logicalKey == LogicalKeyboardKey.space) {
          player.jump();
        }
      } else if (event is KeyUpEvent) {
        pressedKeys.remove(event.logicalKey);
      }
    }
    return KeyEventResult.handled;
  }

  // 新增：暂停游戏方法
  void pauseGame() {
    isPaused = true;
    pauseEngine();
  }

  // 新增：继续游戏方法
  void resumeGame() {
    isPaused = false;
    resumeEngine();
  }
}
