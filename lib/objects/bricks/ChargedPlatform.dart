import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';

class ChargedPlatform
    extends
        SpriteComponent // 修改1: 继承SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition; // 图块在图集中的位置
  final int type;
  final double gridSize;
  static const double jumpBoostMultiplier = 1.5; // 跳跃提升倍数
  double? _originalJumpSpeed; // 记录玩家原始跳跃速度

  ChargedPlatform({
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

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      final playerBottom = other.position.y + other.size.y;
      final brickTop = position.y;

      // 只在玩家从上方站在平台上时增加跳跃高度
      if (playerBottom <= brickTop + 10) {
        // 只在第一次碰到时记录和修改速度
        if (_originalJumpSpeed == null) {
          // 记录当前速度（应该是250，玩家的基础速度）
          _originalJumpSpeed = 250.0; // 直接使用基础值而不是读取
          // 设置新的跳跃速度
          other.jumpSpeed = _originalJumpSpeed! * jumpBoostMultiplier;
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Player && _originalJumpSpeed != null) {
      // 恢复原始跳跃高度
      other.jumpSpeed = _originalJumpSpeed!;
      _originalJumpSpeed = null;
    }
  }
}
