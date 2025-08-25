import 'package:_2d_platformergame/utils/audiomanage.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';

/// 可收集星星，使用tileset渲染
class Star extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  Star({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(16),
        anchor: Anchor.topLeft,
        priority: 5,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(16 * 16, 11 * 16),
      srcSize: Vector2.all(16 * 3),
    );
    add(
      RectangleHitbox(
        size: size * 0.7,
        position: (size - size * 0.7) / 2,
        anchor: Anchor.topLeft,
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Player) {
      // 增加玩家收集品数量
      other.collectiblesCount++;
      // 播放音效
      AudioManage().play('star.mp3');
      // 粒子特效
      parent?.add(
        Particles.collectBurst(
          position + size / 2,
          color: const Color(0xFFFFF176), // 明亮黄
        ),
      );
      // 移除自身
      removeFromParent();
    }
  }
}
