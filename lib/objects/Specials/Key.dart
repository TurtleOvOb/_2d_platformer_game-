import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/utils/audiomanage.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// 钥匙组件，用于开启对应类型的钥匙方块
/// type: 0 - 黄钥匙，1 - 蓝钥匙
class Key extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type; // 0表示黄钥匙，1表示蓝钥匙
  final double gridSize;

  Key({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(position: brickpos, anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 从图块集加载钥匙纹理
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2(gridSize, gridSize),
    );

    // 添加碰撞箱（可根据需要调整大小）
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.8, gridSize * 0.8),
        position: Vector2(gridSize * 0.1, gridSize * 0.1),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      // 不同类型钥匙的粒子效果颜色
      Color burstColor;
      if (type == 0) {
        AudioManage().playkey1();

        // 黄钥匙
        burstColor = const Color(0xFFFFD54F);
      } else {
        // 蓝钥匙
        AudioManage().playkey1();

        burstColor = const Color(0xFF42A5F5);
      }

      parent?.add(Particles.collectBurst(center.clone(), color: burstColor));
      collectKey();
    }
  }

  void collectKey() {
    // 从游戏中移除钥匙
    removeFromParent();
    game.removeKeyBlock(type);
  }
}
