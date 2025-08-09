import 'package:_2d_platformergame/objects/bricks/brick.dart';
import 'package:_2d_platformergame/objects/bricks/half_brick.dart';

import 'package:_2d_platformergame/objects/bricks/key_block1.dart';
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
          // 先修正位置
          player.position.x = other.toRect().left - player.size.x;
          // 只有在地面且速度向右时归零
          if ((player as dynamic).isGrounded == true && playerspeed.x > 0) {
            playerspeed.x = 0;
          }
          // 防止卡墙：如果修正后仍有重叠，微调出墙体
          if (player.toRect().right > other.toRect().left) {
            player.position.x = other.toRect().left - player.size.x - 0.1;
          }
          break;
        case CollisionDirection.right:
          player.position.x = other.toRect().right;
          if ((player as dynamic).isGrounded == true && playerspeed.x < 0) {
            playerspeed.x = 0;
          }
          if (player.toRect().left < other.toRect().right) {
            player.position.x = other.toRect().right + 0.1;
          }
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
