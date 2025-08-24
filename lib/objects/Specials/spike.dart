import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart'; // 添加Sprite导入

class Spike extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  // 移除spikeSize硬编码，使用gridSize计算
  final Vector2 brickpos;
  final Vector2 srcPosition;

  /// type: 0-地面, 1-天花板, 2-左墙, 3-右墙
  final int type;
  final double gridSize;

  Spike({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(position: brickpos, anchor: Anchor.topLeft); // 初始化位置和锚点

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 不旋转碰撞箱，type只影响碰撞箱在本格内的位置
    Vector2 hitboxPos;
    if (type == 0) {
      // 地面
      hitboxPos = Vector2(gridSize * 0.2, gridSize * 0.4);
    } else if (type == 1) {
      // 天花板
      hitboxPos = Vector2(gridSize * 0.2, 0);
    } else if (type == 2) {
      // 左墙
      hitboxPos = Vector2(0, gridSize * 0.2);
    } else if (type == 3) {
      // 右墙
      hitboxPos = Vector2(gridSize * 0.4, gridSize * 0.2);
    } else {
      hitboxPos = Vector2(gridSize * 0.2, gridSize * 0.4);
    }
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2(gridSize, gridSize),
    );
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.6, gridSize * 0.6),
        position: hitboxPos,
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    // 检测是否与玩家发生碰撞
    if (other is Player) {
      // 调用游戏死亡方法，而不是直接重置关卡
      game.playerDeath();
    }
  }
}
