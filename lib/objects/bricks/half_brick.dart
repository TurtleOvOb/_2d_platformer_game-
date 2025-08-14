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
         position: Vector2(
           brickpos.x.floorToDouble(),
           brickpos.y.floorToDouble(),
         ),
         size: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
         anchor: Anchor.topLeft,
       );

  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 修改2: 从图块集加载半砖纹理
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble(),
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
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
