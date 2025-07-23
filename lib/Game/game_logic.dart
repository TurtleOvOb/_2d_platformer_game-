import 'package:_2d_platformergame/bricks/brick.dart';
import '../levels/ldtk_parser.dart';
import 'package:_2d_platformergame/player/player.dart';
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
        camera: CameraComponent.withFixedResolution(width: 1280, height: 600),
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
    initial();
  }

  Future<void> initial() async {
    world.add(player = Player(spawnPosition: Vector2(0, -100)));
    await BrickGenerator();
    debugMode = true;
  }

  Future<void> BrickGenerator() async {
    final parser = LdtkParser();
    final bricks = await parser.parseLdtkLevel('assets/levels/main_level.ldtk');
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
