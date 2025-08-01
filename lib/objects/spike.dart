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

    // 修改2: 从图块集加载半砖纹理
    sprite = await Sprite.load(
      'tileset.png', // 图块集路径
      srcPosition: srcPosition, // 从构造函数传入的图块位置
      srcSize: Vector2(gridSize, gridSize), // 半砖尺寸
    );

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
}
