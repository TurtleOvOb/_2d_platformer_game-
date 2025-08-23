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

    // 修改2: 从图块集加载半砖纹理
    sprite = await Sprite.load(
      'tileset.png', // 图块集路径
      srcPosition: srcPosition, // 从构造函数传入的图块位置
      srcSize: Vector2(gridSize, gridSize), // 半砖尺寸
    );

    // 添加碰撞盒以便检测碰撞
    // type==0: 地面spike，碰撞箱靠下；type==1: 悬挂spike，碰撞箱靠上
    final hitboxY = (type == 1) ? gridSize * 0.0 : gridSize * 0.4;
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.6, gridSize * 0.6),
        position: Vector2(gridSize * 0.2, hitboxY),
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
