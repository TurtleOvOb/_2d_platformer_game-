import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class DoorBlock extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  DoorBlock({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(
         position: brickpos,
         anchor: Anchor.topLeft,
         size: Vector2(gridSize, gridSize * 2), // 明确设置为两格高
         priority: -1, // 优先级设为较低，确保玩家在其之上
       );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 从图块集加载门纹理 (两格高)
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2(gridSize, 2 * gridSize),
    );

    // 添加碰撞箱（调整为两格高）
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.8, gridSize * 1.8), // 高度为两格
        position: Vector2(gridSize * 0.1, gridSize * 0.1),
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    print('1');
    super.onCollision(points, other);
    if (other is Player) {
      final player = other;
      player.lockControl(); // 禁用玩家所有操作
      // 计算目标点：门下方一格中心
      final double targetX = position.x + gridSize / 2 - player.size.x / 2;
      final double targetY = position.y + gridSize * 1.5 - player.size.y / 2;
      player.add(
        MoveEffect.to(
          Vector2(targetX, targetY),
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        ),
      );
      player.add(
        OpacityEffect.to(
          0,
          EffectController(duration: 0.5, curve: Curves.easeIn),
          onComplete: () {
            endLevel();
          },
        ),
      );
    }
  }

  // 通过本关卡
  void endLevel() {
    print('6: endLevel called');
    if (game.isInitialized) {
      print('7: game.isInitialized, call game.endLevel');
      game.endLevel();
    } else {
      print('8: 游戏尚未完全初始化，无法触发通关逻辑');
    }
  }
}
