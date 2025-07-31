import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Brick extends PositionComponent with CollisionCallbacks {
  final int gridSize; // 网格大小
  final Vector2 Brickpos;
  final Vector2 srcPosition;
  final int type;
  final NotifyingVector2 size;

  Brick({
    required Vector2 brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : Brickpos = brickpos,
       size = NotifyingVector2(gridSize.toDouble(), gridSize.toDouble()) {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Brickpos;
    add(
      RectangleHitbox(
        //  anchor: anchor,
        collisionType: CollisionType.passive,
        size: size,
      ),
    );
  }

  @override
  void onMount() {
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    // 使用整数尺寸确保像素对齐
    final rect = Rect.fromLTWH(
      0,
      0,
      size.x.roundToDouble(),
      size.y.roundToDouble(),
    );
    final paint = Paint()..color = Color.fromARGB(255, 255, 141, 26);

    canvas.drawRect(rect, paint);
  }
}
