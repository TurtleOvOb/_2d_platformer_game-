import 'dart:ui';

import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';

class KeyBlock extends PositionComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  KeyBlock({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) {
    position = brickpos;
    size = Vector2(gridSize, gridSize);
  }

  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;
  late Sprite keySprite;
  bool isCollected = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox = RectangleHitbox(
      collisionType: CollisionType.active,
      size: Vector2(2 * gridSize, 2 * gridSize),
    );
    add(hitbox);
    keySprite = await Sprite.load('KeyBlock1.png');
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 通过调整size参数来改变缩放比例
    final scaledSize = Vector2(size.x * 1, size.y * 2); // 示例：放大1.5倍
    keySprite.render(canvas, size: scaledSize);
  }
}
