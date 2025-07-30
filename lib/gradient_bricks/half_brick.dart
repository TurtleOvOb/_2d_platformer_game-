import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/game_logic.dart';

class HalfBrick extends PositionComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  HalfBrick({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) {
    position = brickpos;
    size = Vector2(gridSize, gridSize / 2);
  }

  // 保持与Brick类相同的属性和方法
  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox = RectangleHitbox(collisionType: CollisionType.passive, size: size);
    add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 绘制半砖矩形，使用红色以便区分
    final paint = Paint()..color = Color.fromARGB(255, 255, 141, 26);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final player = game.player;

    // 计算玩家底部和半砖顶部坐标
    final playerBottom = player.position.y + player.size.y;
    final brickTop = position.y;
    final brickBottom = position.y + size.y;

    hitbox.collisionType =
        (playerBottom <= brickTop + 10) // 添加10像素容差
            ? CollisionType
                .passive // 使用passive类型配合玩家active碰撞
            : CollisionType.inactive;
    //print('HalfBrick collision type: ${hitbox.collisionType}');
  }
}
