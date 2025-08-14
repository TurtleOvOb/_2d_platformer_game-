import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../player/player.dart';

class WhiteBlock extends SpriteComponent with CollisionCallbacks {
  Color color;
  final Vector2 blockPos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  WhiteBlock({
    required this.blockPos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
    this.color = Colors.white,
  }) {
    position = Vector2(blockPos.x.floorToDouble(), blockPos.y.floorToDouble());
    size = Vector2.all(gridSize.floorToDouble());
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 默认渲染为白色方块，若color为白色则用tileset.png渲染，否则用color渲染
    if (color == Colors.white) {
      sprite = await Sprite.load(
        'tileset.png',
        srcPosition: Vector2(
          srcPosition.x.floorToDouble(),
          srcPosition.y.floorToDouble(),
        ),
        srcSize: Vector2.all(gridSize.floorToDouble()),
      );
    }
    add(RectangleHitbox(collisionType: CollisionType.passive, size: size));
  }

  @override
  void render(Canvas canvas) {
    if (color == Colors.white) {
      super.render(canvas);
    } else {
      // 用color渲染纯色方块
      final paint = Paint()..color = color;
      canvas.drawRect(size.toRect(), paint);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      // 只有玩家颜色不是白色时才吸收
      if (other.color != Colors.white) {
        color = other.color;
        other.color = Colors.white;
      }
    }
  }
}
