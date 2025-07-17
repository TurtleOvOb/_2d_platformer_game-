import 'package:_2d_platformergame/bricks/brick.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
// 引入 World 类
import 'player/player.dart';
import 'package:flutter/services.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, KeyboardEvents {
  // 添加 KeyboardEvents 混合
  //final World world = World(); // 定义 world 对象
  late Player player;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  @override
  Color backgroundColor() => Colors.deepOrange;
  @override
  void onLoad() async {
    await super.onLoad();
    // 将 world 添加到游戏中
  }

  @override
  void onMount() {
    super.onMount();
    world.add(player = Player());
    // 传入不同的位置向量
    debugMode = true;
    world.add(Brick(brickpos: Vector2(200, 300)));
    BrickGenerator();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    player.jump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isLeftPressed) {
      player.moveLeft();
    } else if (isRightPressed) {
      player.moveRight();
    } else {
      player.stopHorizontal();
    }
  }

  // 处理键盘事件
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
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
    return KeyEventResult.handled;
  }

  void BrickGenerator() {
    world.add(Brick(brickpos: Vector2(0, 300)));
  }
}
