import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';

class KeyBlock1 extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  KeyBlock1({
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
    sprite = await Sprite.load(
      'tileset.png', // 图块集路径
      srcPosition: srcPosition, // 从构造函数传入的图块位置
      srcSize: Vector2(gridSize, gridSize), // 半砖尺寸
    );

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2(gridSize, gridSize),
      ),
    );
  }
}
