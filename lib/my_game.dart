import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'player.dart';
import 'package:flutter/services.dart';

class MyGame extends FlameGame with TapCallbacks {
  late Player player;
  bool isLeftPressed = false;
  bool isRightPressed = false;

  @override
  void onMount() {
    super.onMount();
    player = Player();
    world.add(player);
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
  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        isLeftPressed = true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        isRightPressed = true;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        player.jump();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        isLeftPressed = false;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        isRightPressed = false;
      }
    }
  }
}
