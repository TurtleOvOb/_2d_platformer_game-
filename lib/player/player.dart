import 'package:_2d_platformergame/player/collision_logic.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks {
  Player({super.position, required this.spawnPosition})
    : super(size: Vector2(32, 32));
  Vector2 spawnPosition;
  final Vector2 playersize = Vector2(16.0, 16.0); // 玩家大小，和图片尺寸一致
  final Vector2 playerspeed = Vector2(0.0, 0.0); // 玩家速度
  final double gravity = 980; // 重力
  final double moveSpeed = 100; // 移动速度
  final double jumpSpeed = 250;
  bool isGrounded = false; // 标记玩家是否在地面

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
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.12);
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
    playerspeed.y += gravity * dt;
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

  void jump() {
    if (isGrounded) {
      playerspeed.y = -jumpSpeed;
      isGrounded = false; // 跳跃后标记为不在地面
    }
  }

  // 向左移动
  void moveLeft() {
    playerspeed.x = -moveSpeed;
  }

  // 向右移动
  void moveRight() {
    playerspeed.x = moveSpeed;
  }

  // 停止水平移动
  void stopHorizontal() {
    playerspeed.x = 0;
  }
}
