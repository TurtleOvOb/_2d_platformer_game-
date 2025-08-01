import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart'; // 添加Sprite导入
import 'package:flutter/material.dart';
import '../pages/deathpage.dart';

class Spike extends SpriteComponent with CollisionCallbacks {
  // 移除spikeSize硬编码，使用gridSize计算
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  Spike({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(position: brickpos, anchor: Anchor.topLeft); // 初始化位置和锚点

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 加载图片资源
    sprite = await Sprite.load('spike1.png');
    // 设置尺寸为网格大小
    size = Vector2(gridSize, gridSize);
    // 保持碰撞盒
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  // 移除原有的render方法
  /*   @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      // 导航到死亡页面
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DeathPage()),
      );
    }
  }   */
}
