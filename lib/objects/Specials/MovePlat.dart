import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../../Game/My_Game.dart';
import '../../player/player.dart';

/// 移动平台：实体，可站立，不致死，按固定路线往返移动
class MovePlat extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 startPosition;
  final Vector2 endPosition;
  final double speed;

  bool movingToStart = false;
  final List<Player> playersOnPlatform = [];

  MovePlat({
    required this.startPosition,
    required this.endPosition,
    required this.speed,
  }) : super(
         position: startPosition.clone(),
         size: Vector2(32, 8), // 平台尺寸可调整
         anchor: Anchor.topLeft,
         priority: 5,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 加载平台精灵
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(2 * 16, 15 * 16), // 假设平台图块在tileset第13行
      srcSize: Vector2(2 * 16, 16),
    );
    // 添加碰撞箱
    add(
      RectangleHitbox(
        size: size * 0.9,
        position: size * 0.05,
        anchor: Anchor.topLeft,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    double currentSpeed = speed;
    Vector2 moveVector = Vector2.zero();
    if (!movingToStart) {
      moveVector =
          (endPosition - startPosition).normalized() * currentSpeed * dt;
      position.add(moveVector);
      if ((endPosition - position).length < currentSpeed * dt) {
        position.setFrom(endPosition);
        movingToStart = true;
      }
    } else {
      moveVector =
          (startPosition - endPosition).normalized() * currentSpeed * dt;
      position.add(moveVector);
      if ((startPosition - position).length < currentSpeed * dt) {
        position.setFrom(startPosition);
        movingToStart = false;
      }
    }
    // 平台带动玩家移动
    for (final player in playersOnPlatform) {
      player.position += moveVector;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Player && !playersOnPlatform.contains(other)) {
      // 玩家站上平台
      playersOnPlatform.add(other);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Player) {
      playersOnPlatform.remove(other);
    }
  }
}
