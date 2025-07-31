import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../pages/deathpage.dart';

class Spike extends PositionComponent with CollisionCallbacks {
  final Vector2 spikeSize = Vector2(10.0, 10.0);
  //final BuildContext context;
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;
  Spike({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  });

  @override
  void onLoad() {
    super.onLoad();
    size = spikeSize;
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

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
  } */

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Draw spike shape
    final paint = Paint()..color = Colors.red;
    final path =
        Path()
          ..moveTo(0, size.y)
          ..lineTo(size.x / 2, 0)
          ..lineTo(size.x, size.y)
          ..close();
    canvas.drawPath(path, paint);
  }
}
