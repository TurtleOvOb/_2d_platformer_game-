import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';

class HalfBrick
    extends
        SpriteComponent // 修改1: 继承SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition; // 图块在图集中的位置
  final int type;
  final double gridSize;

  HalfBrick({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(
         position: brickpos,
         size: Vector2(gridSize, gridSize), // 半砖高度为gridSize/2
         anchor: Anchor.topLeft, // 保持与其他块相同的锚点
       );

  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 修改2: 从图块集加载半砖纹理
    sprite = await Sprite.load(
      'tileset.png', // 图块集路径
      srcPosition: srcPosition, // 从构造函数传入的图块位置
      srcSize: Vector2(gridSize, gridSize), // 半砖尺寸
    );

    // 保持原有碰撞箱逻辑
    hitbox = RectangleHitbox(collisionType: CollisionType.passive, size: size);
    add(hitbox);
  }

  // 修改3: 移除手动render方法，由SpriteComponent自动渲染

  @override
  void update(double dt) {
    super.update(dt);

    final player = game.player;
    if (player == null) return;

    // 原有碰撞逻辑保持不变
    final playerBottom = player.position.y + player.size.y;
    final brickTop = position.y;

    hitbox.collisionType =
        (playerBottom <= brickTop + 10)
            ? CollisionType.passive
            : CollisionType.inactive;
  }
}
