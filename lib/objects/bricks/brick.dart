import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

// 修改类继承，使用SpriteComponent
class Brick extends SpriteComponent with CollisionCallbacks {
  final int gridSize; // 网格大小
  final Vector2 Brickpos;
  final Vector2 srcPosition; // 图块在图集中的位置
  final int type;

  Brick({
    required Vector2 brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : Brickpos = Vector2(
         brickpos.x.floorToDouble(),
         brickpos.y.floorToDouble(),
       ) {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position = Vector2(Brickpos.x.floorToDouble(), Brickpos.y.floorToDouble());
    // 加载图块集纹理，确保采样整数像素
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble(),
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2.all(gridSize.floorToDouble()),
    );
    size = Vector2.all(gridSize.floorToDouble() + 1); // 比网格大1px，避免缝隙
    // 保留碰撞检测，碰撞箱保持原始大小
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(gridSize.floorToDouble()),
      ),
    );
  }
}
