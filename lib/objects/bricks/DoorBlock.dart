import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class DoorBlock extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  DoorBlock({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(
         position: brickpos,
         anchor: Anchor.topLeft,
         size: Vector2(gridSize, gridSize * 2), // 明确设置为两格高
       );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 从图块集加载门纹理 (两格高)
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2(gridSize, 2 * gridSize),
    );

    // 添加碰撞箱（调整为两格高）
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.8, gridSize * 1.8), // 高度为两格
        position: Vector2(gridSize * 0.1, gridSize * 0.1),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      // 玩家碰到门时触发通关逻辑
      endLevel();
    }
  }

  // 通过本关卡
  void endLevel() {
    // 确保游戏已经初始化且可以安全地调用endLevel方法
    if (game.isInitialized) {
      // 调用游戏中的通关方法
      game.endLevel();
    } else {
      print('游戏尚未完全初始化，无法触发通关逻辑');
    }
  }
}
