import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

/// 传送带类，玩家站在上面时会自动向指定方向移动
class ConveyorBelt extends SpriteComponent with CollisionCallbacks {
  // 传送带基本参数
  final Vector2 brickpos; // 图块位置
  final Vector2 srcPosition; // 在图块集中的位置
  final int type;
  final double gridSize; // 网格大小
  final int beltDirection; // 传送方向: 1=右, -1=左
  final double beltSpeed; // 传送带速度

  // 状态参数
  final List<Player> _playersOnBelt = []; // 跟踪站在传送带上的玩家

  /// 构造函数
  ConveyorBelt({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
    required this.beltDirection,
    this.beltSpeed = 128.0, // 默认速度，可调整
  }) : super(size: Vector2.all(gridSize.floorToDouble() + 1)) {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 设置位置
    position = Vector2(brickpos.x.floorToDouble(), brickpos.y.floorToDouble());

    // 使用图块集渲染
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble(),
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
    );

    // 添加碰撞检测
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        position: Vector2.zero(),
        size: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
      ),
    );

    // 添加动画效果，模拟传送带移动
    // 使用一个简单的颜色效果表示活动状态
    /* add(
      ColorEffect(
        Colors.amber.withOpacity(0.6), // 琥珀色半透明
        EffectController(duration: 0.3, reverseDuration: 0.3, infinite: true),
      ), */
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 对所有站在传送带上的玩家应用水平力
    for (final player in _playersOnBelt) {
      // 仅在玩家站在地面时移动
      if (player.isGrounded) {
        // 记录传送带信息，使玩家起跳时可以继承速度
        player.conveyorBeltSpeed = beltSpeed;
        player.conveyorBeltDirection = beltDirection;

        // 施加水平力，移动玩家
        // 使用两种力:
        // 1. 直接位移 - 确保玩家一定会移动
        // 2. 速度增量 - 确保玩家动量逐渐增加

        // 直接位移 (小量移动，避免抖动)
        player.position.x += beltDirection * beltSpeed * 0.3 * dt;

        // 速度增量 (玩家可以通过按键部分抵抗，但不能完全停下)
        player.playerspeed.x += beltDirection * beltSpeed * 0.7 * dt;

        // 如果玩家反方向按键，让他能稍微减缓但不能完全抵消传送带
        if ((beltDirection > 0 && player.playerspeed.x < 0) ||
            (beltDirection < 0 && player.playerspeed.x > 0)) {
          player.playerspeed.x *= 0.9; // 减弱反方向输入
        }
      }
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      // 使用 isGrounded 属性来判断玩家是否站在传送带上
      if (other.isGrounded && !_playersOnBelt.contains(other)) {
        _playersOnBelt.add(other);
      }
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      // 使用 isGrounded 属性来判断玩家是否站在传送带上
      if (other.isGrounded && !_playersOnBelt.contains(other)) {
        _playersOnBelt.add(other);
      } else if (!other.isGrounded && _playersOnBelt.contains(other)) {
        _playersOnBelt.remove(other);
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // 玩家离开传送带时，从列表中移除并重置传送带信息
    if (other is Player && _playersOnBelt.contains(other)) {
      _playersOnBelt.remove(other);
      // 重置传送带数据
      other.conveyorBeltDirection = 0;
      other.conveyorBeltSpeed = 0.0;
    }
  }
}
