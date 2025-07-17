import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Brick extends PositionComponent with CollisionCallbacks {
  final Vector2 bricksize = Vector2(50, 50);
  // 定义圆角半径
  final double borderRadius = 8.0;
  final Vector2 Brickpos;
  // 按照 Dart 命名规范修改参数名
  Brick({required Vector2 brickpos}) : Brickpos = brickpos;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Brickpos;
    add(
      RectangleHitbox(
        anchor: anchor,
        collisionType: CollisionType.passive,
        size: bricksize,
      ),
    );
  }

  // 修改 onMount 方法，移除对 position 的硬编码
  @override
  void onMount() {
    super.onMount();
    size = bricksize;
  }

  @override
  void render(Canvas canvas) {
    // 使用 RRect 绘制圆角矩形
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(rrect, Paint()..color = Colors.orangeAccent);
  }
}
