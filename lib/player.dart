import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
  Player({super.position});
  final Vector2 playersize = Vector2(10.0, 10.0);
  final Vector2 playerspeed = Vector2(100.0, 0.0);
  final double gravity = 800;
  final double moveSpeed = 200; // 移动速度

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
    canvas.drawRect(size.toRect(), Paint()..color = Colors.red);
  }

  void jump() {
    playerspeed.y = -300;
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
