import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'dart:math';

class MovingStar extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 startPosition;
  final Vector2 endPosition;
  final double speed;

  bool movingToStart = false;
  final List<Player> playersOnPlatform = [];

  // 用于速度变化的时间累加器
  double _timeAccumulator = 0;
  // 基础速度和速度变化范围
  static const double _baseSpeed = 65.0; // 中间速度
  static const double _speedRange = 35.0; // 变化幅度

  MovingStar({
    required this.startPosition,
    required this.endPosition,
    required this.speed,
  }) : super(
         position: startPosition.clone(),
         size: Vector2.all(16),
         anchor: Anchor.topLeft,
         priority: 10,
       );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(14 * 16, 12 * 16),
      srcSize: Vector2.all(16),
    );

    // 添加更小的碰撞箱（缩小为0.6倍并居中）
    final double hitboxScale = 0.6;
    final Vector2 hitboxSize = size * hitboxScale;
    final Vector2 hitboxPos = (size - hitboxSize) / 2;
    add(
      RectangleHitbox(
        size: hitboxSize,
        position: hitboxPos,
        anchor: Anchor.topLeft,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 匀速运动，速度为构造参数speed
    double currentSpeed = speed;

    if (!movingToStart) {
      // 向终点移动
      final Vector2 moveVector =
          (endPosition - startPosition).normalized() * currentSpeed * dt;
      position.add(moveVector);

      if ((endPosition - position).length < currentSpeed * dt) {
        position.setFrom(endPosition);
        movingToStart = true;
      }
    } else {
      // 向起点移动
      final Vector2 moveVector =
          (startPosition - endPosition).normalized() * currentSpeed * dt;
      position.add(moveVector);

      if ((startPosition - position).length < currentSpeed * dt) {
        position.setFrom(startPosition);
        movingToStart = false;
      }
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Player) {
      playersOnPlatform.add(other);
      // 玩家碰到MoveStar判定为死亡
      game.playerDeath();
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
