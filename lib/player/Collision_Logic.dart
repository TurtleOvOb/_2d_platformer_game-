import 'package:_2d_platformergame/objects/brick.dart';
import 'package:_2d_platformergame/objects/half_brick.dart';
import 'package:_2d_platformergame/objects/key_block1.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

// 计算碰撞方向的枚举
enum CollisionDirection { top, bottom, left, right }

class CollisionLogic {
  // 计算碰撞方向的方法
  static CollisionDirection calculateCollisionDirection(
    Rect playerRect,
    Rect brickRect,
  ) {
    final dx = playerRect.center.dx - brickRect.center.dx;
    final dy = playerRect.center.dy - brickRect.center.dy;
    final width = (playerRect.width + brickRect.width) / 2;
    final height = (playerRect.height + brickRect.height) / 2;
    final crossWidth = width * dy;
    final crossHeight = height * dx;

    if (crossWidth > crossHeight) {
      return crossWidth > -crossHeight
          ? CollisionDirection.bottom
          : CollisionDirection.left;
    } else {
      return crossWidth > -crossHeight
          ? CollisionDirection.right
          : CollisionDirection.top;
    }
  }

  // 处理碰撞的方法
  static void handleCollision(
    PositionComponent player,
    Vector2 playerspeed,
    bool Function(bool) setIsGrounded,
    Set<Vector2> points,
    PositionComponent other,
  ) {
    if (other is Brick || other is KeyBlock) {
      final collisionDirection = calculateCollisionDirection(
        player.toRect(),
        other.toRect(),
      );
      switch (collisionDirection) {
        case CollisionDirection.top:
          playerspeed.y = 0;
          player.position.y = other.toRect().top - player.size.y;
          setIsGrounded(true);
          break;
        case CollisionDirection.bottom:
          playerspeed.y = 0;
          player.position.y = other.toRect().bottom;
          break;
        case CollisionDirection.left:
          playerspeed.x = 0;
          player.position.x = other.toRect().left - player.size.x;
          break;
        case CollisionDirection.right:
          playerspeed.x = 0;
          player.position.x = other.toRect().right;
          break;
      }
    } else if (other is HalfBrick) {
      // 半砖特殊穿越逻辑
      // 只有当玩家速度向下且位置在半砖上方时才允许碰撞
      if (playerspeed.y > 0 &&
          player.toRect().bottom <= other.toRect().top + 10) {
        final collisionDirection = calculateCollisionDirection(
          player.toRect(),
          other.toRect(),
        );
        if (collisionDirection == CollisionDirection.top) {
          playerspeed.y = 0;
          player.position.y = other.toRect().top - player.size.y;
          setIsGrounded(true);
        }
      }
    }
  }

  // 处理碰撞结束的方法
  static void handleCollisionEnd(
    bool Function(bool) setIsGrounded,
    PositionComponent other,
  ) {
    if (other is Brick) {
      // 当玩家离开砖块时，标记为不在地面
      setIsGrounded(false);
    }
  }
}
