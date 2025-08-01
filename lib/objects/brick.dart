import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// 修改类继承，使用SpriteComponent
class Brick extends SpriteComponent with CollisionCallbacks {
  final int gridSize; // 网格大小
  final Vector2 Brickpos;
  final Vector2 srcPosition; // 图块在图集中的位置
  final int type;

  Brick({
    required Vector2 brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : Brickpos = brickpos {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Brickpos;
    // 加载图块集纹理
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2.all(gridSize.toDouble()),
    );
    // 保留碰撞检测
    add(RectangleHitbox(collisionType: CollisionType.passive, size: size));
  }

  @override
  void onMount() {
    super.onMount();
  }

  // 移除手动渲染方法
}
