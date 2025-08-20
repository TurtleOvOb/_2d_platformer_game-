import 'package:_2d_platformergame/player/collision_logic.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks {
  Color color = Colors.white;
  Player({super.position, required this.spawnPosition})
    : super(size: Vector2(32, 32));
  Vector2 spawnPosition;
  final Vector2 playersize = Vector2(16.0, 16.0); // 玩家大小，和图片尺寸一致
  final Vector2 playerspeed = Vector2(0.0, 0.0); // 玩家速度
  // 当前站立的传送带速度 (如果有)
  double conveyorBeltSpeed = 0.0;
  int conveyorBeltDirection = 0;
  // 基础物理参数
  final double gravity = 980; // 基础重力
  final double moveSpeed = 150; // 地面最大移动速度
  double jumpSpeed = 250; // 跳跃速度（向上为负）
  // 手感增强参数
  final double groundAccel = 2100; // 地面加速度
  final double groundDecel = 300; // 地面减速度
  final double groundFriction = 1400; // 地面摩擦（无输入时）
  final double airAccel = 600; // 空中加速度
  final double airDecel = 900; // 空中减速度
  final double fallGravityMultiplier = 1.6; // 下落时加重力
  final double shortHopGravityMultiplier = 2.0; // 松开跳跃键时的上升重力
  final double maxFallSpeed = 900; // 最大下落速度
  final double coyoteTime = 0.2; // 土狼时间（离地后仍可跳）
  final double jumpBufferTime = 0.12; // 跳跃缓冲（落地前按跳跃）
  double _coyoteTimer = 0;
  double _jumpBufferTimer = 0;
  bool _jumpHeld = false;
  int _desiredDir = 0; // -1 左, 0 停, 1 右
  bool isGrounded = false; // 标记玩家是否在地面
  bool isDashing = false; // 标记玩家是否在冲刺中
  double levelTime = 0; // 当前关卡已用时间（秒）
  int deathCount = 0; // 当前关卡死亡次数
  int collectiblesCount = 0; // 当前关卡收集品数量

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 加载动画帧
    final images = [
      await Flame.images.load('Player/Frame1.png'),
      await Flame.images.load('Player/Frame2.png'),
      await Flame.images.load('Player/Frame3.png'),
      await Flame.images.load('Player/Frame4.png'),
    ];
    final sprites = images.map((img) => Sprite(img)).toList();
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.15);
    size = playersize;
    add(
      RectangleHitbox(
        anchor: anchor,
        collisionType: CollisionType.active,
        size: playersize,
      ),
    );
  }

  @override
  void onMount() {
    super.onMount();
    position = spawnPosition;
    size = playersize;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 逐渐减弱传送带的影响（当玩家已经离开传送带但保留了部分速度）
    if (conveyorBeltDirection == 0 &&
        isGrounded &&
        playerspeed.x.abs() > moveSpeed) {
      // 当玩家在地面上且没有站在任何传送带上，但速度超过了普通移动速度，
      // 这可能是从传送带上跳下来后的情况，应该逐渐减弱这个效果
      playerspeed.x = _moveToward(
        playerspeed.x,
        _desiredDir * moveSpeed,
        groundFriction * dt * 1.5,
      );
    }

    // 1) 水平移动：根据期望方向进行加减速与摩擦
    final bool hasInput = _desiredDir != 0;
    final double targetVx = _desiredDir * moveSpeed;
    double ax;
    if (hasInput) {
      // 有输入：朝目标速度推进
      final bool speedingUp = (targetVx.abs() > playerspeed.x.abs());
      if (isGrounded) {
        ax =
            (speedingUp ? groundAccel : groundDecel) *
            _sign(targetVx - playerspeed.x);
      } else {
        ax =
            (speedingUp ? airAccel : airDecel) *
            _sign(targetVx - playerspeed.x);
      }
      playerspeed.x += ax * dt;
      // 限制到目标范围
      if ((playerspeed.x - targetVx).abs() < 2) {
        playerspeed.x = targetVx;
      }
    } else {
      // 无输入：地面摩擦快速停下，空中则缓慢减速
      if (isGrounded) {
        playerspeed.x = _moveToward(playerspeed.x, 0, groundFriction * dt);
      } else {
        playerspeed.x = _moveToward(playerspeed.x, 0, airDecel * 0.5 * dt);
      }
    }

    // 2) 垂直移动：重力（可变跳高 + 下落加速 + 冲刺时减弱重力）
    double gScale = 1.0;

    if (isDashing) {
      // 冲刺状态：大幅减弱重力，提供滞空效果
      gScale = 0.1; // 只有10%的重力
    } else if (playerspeed.y < 0) {
      // 上升期：若未按住跳跃键，给予更大的重力 -> 短跳
      gScale = _jumpHeld ? 1.0 : shortHopGravityMultiplier;
    } else if (playerspeed.y > 0) {
      // 下落期：加大重力
      gScale = fallGravityMultiplier;
    }

    playerspeed.y += gravity * gScale * dt;
    if (playerspeed.y > maxFallSpeed) playerspeed.y = maxFallSpeed;

    // 3) 土狼时间 & 跳跃缓冲计时
    if (isGrounded) {
      _coyoteTimer = coyoteTime;
    } else {
      _coyoteTimer = (_coyoteTimer - dt).clamp(0, coyoteTime);
    }
    _jumpBufferTimer = (_jumpBufferTimer - dt).clamp(0, jumpBufferTime);

    // 4) 若有跳跃请求且满足条件则执行
    if (_jumpBufferTimer > 0 && (_coyoteTimer > 0 || isGrounded)) {
      _doJump();
      _jumpBufferTimer = 0;
      _coyoteTimer = 0;
    }

    // 5) 移动位置
    position += playerspeed * dt;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    CollisionLogic.handleCollision(
      this,
      playerspeed,
      (value) => isGrounded = value,
      points,
      other,
    );
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    CollisionLogic.handleCollisionEnd((value) => isGrounded = value, other);
  }

  // 旧 jump() 保持兼容，改为发出跳跃请求
  void jump() => requestJump();

  // 跳跃请求（支持缓冲）
  void requestJump() {
    _jumpHeld = true;
    _jumpBufferTimer = jumpBufferTime;
  }

  // 跳跃键释放用于可变跳高
  void releaseJump() {
    _jumpHeld = false;
  }

  void _doJump() {
    // 起跳灰尘（略带玩家色调）
    final c = color;
    final tinted = Color.fromARGB(
      255,
      (c.red * 0.8).toInt(),
      (c.green * 0.8).toInt(),
      (c.blue * 0.8).toInt(),
    );
    parent?.add(
      Particles.dust(
        Vector2(position.x + size.x / 2, position.y + size.y),
        color: tinted,
      ),
    );

    // 设置跳跃的垂直速度
    playerspeed.y = -jumpSpeed;

    // 如果站在传送带上，跳跃时继承传送带的水平速度
    if (conveyorBeltDirection != 0) {
      // 给予额外的水平速度增益 - 增加一个跳跃时的水平速度提升
      double boostFactor = 0.6; // 提升系数，可以根据需要调整
      playerspeed.x += conveyorBeltDirection * conveyorBeltSpeed * boostFactor;

      // 记录跳跃速度，但不立即清除传送带方向，让玩家保持一段时间的助推效果
      // 在 onCollisionEnd 中，传送带会重置这些值
    }

    isGrounded = false;
  }

  // 向左移动
  void moveLeft() {
    _desiredDir = -1;
  }

  // 向右移动
  void moveRight() {
    _desiredDir = 1;
  }

  // 停止水平移动
  void stopHorizontal() {
    _desiredDir = 0;
  }

  // 工具函数：逐步靠近
  double _moveToward(double current, double target, double maxDelta) {
    if ((current - target).abs() <= maxDelta) return target;
    return current + _sign(target - current) * maxDelta;
  }

  double _sign(double v) => v == 0 ? 0 : (v > 0 ? 1 : -1);
}
