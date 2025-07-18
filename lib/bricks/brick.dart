import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Brick extends PositionComponent with CollisionCallbacks {
  final Vector2 bricksize = Vector2(50, 50);
  // 定义圆角半径
  final double borderRadius = 8.0;
  final Vector2 Brickpos;

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

  @override
  void onMount() {
    super.onMount();
    size = bricksize;
  }

  @override
  void render(Canvas canvas) {
    // 使用 RRect 绘制圆角矩形
    anchor = Anchor.topLeft;
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(borderRadius),
    );

    // 创建线性渐变
    final gradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 255, 141, 26), // 起始颜色
        Color.fromARGB(0, 255, 141, 26), // 结束颜色
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.2, 0.8],
    );

    // 将渐变应用到 Paint 对象
    final paint = Paint()..shader = gradient.createShader(size.toRect());

    canvas.drawRRect(rrect, paint);
  }
}
