import 'package:_2d_platformergame/bricks/brick.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, KeyboardEvents {
  late Player player;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  double cameraMoveSpeed = 5.0;
  double cameraAcc = 10.0;
  bool isPaused = false; // 新增：暂停状态

  MyGame()
    : super(
        camera: CameraComponent.withFixedResolution(width: 640, height: 600),
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

  void initial() {
    world.add(player = Player(spawnPosition: Vector2(0, -100)));
    BrickGenerator();
    debugMode = true;
  }

  void BrickGenerator() {
    world.add(Brick(brickpos: Vector2(0, 0)));
    world.add(Brick(brickpos: Vector2(50, 0)));
    world.add(Brick(brickpos: Vector2(100, 0)));
    world.add(Brick(brickpos: Vector2(150, 0)));
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
      if (isLeftPressed) {
        player.moveLeft();
      } else if (isRightPressed) {
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
      final isKeyDown = event is KeyDownEvent;
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        isLeftPressed = isKeyDown;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        isRightPressed = isKeyDown;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        if (isKeyDown) {
          player.jump();
        }
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
