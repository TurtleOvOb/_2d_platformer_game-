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

    /*     print('MovingStar - onLoad:');
    print('起始位置: $startPosition');
    print('结束位置: $endPosition');
    print('速度: $speed'); */

    // 加载精灵
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(14 * 16, 12 * 16),
      srcSize: Vector2.all(16),
    );

    // 添加碰撞箱
    add(RectangleHitbox(size: size, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 更新时间累加器
    _timeAccumulator += dt;

    // 使用正弦函数计算当前速度（在30到100之间变化）
    double currentSpeed = _baseSpeed + _speedRange * sin(_timeAccumulator * 2);

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
