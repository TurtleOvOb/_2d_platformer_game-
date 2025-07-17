import 'package:_2d_platformergame/player/collision_logic.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with CollisionCallbacks {
  Player({super.position});
  final Vector2 playersize = Vector2(20.0, 20.0); //玩家大小
  final Vector2 playerspeed = Vector2(0.0, 0.0); //玩家速度
  final double gravity = 980; //重力
  final double moveSpeed = 300; // 移动速度
  bool isGrounded = false; // 标记玩家是否在地面

  @override
  void onLoad() {
    super.onLoad();
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
    position = Vector2(0, 0);
    size = playersize;
  }

  @override
  void update(double dt) {
    playerspeed.y += gravity * dt;
    position += playerspeed * dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.white);
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
      playerspeed.y = -300;
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
