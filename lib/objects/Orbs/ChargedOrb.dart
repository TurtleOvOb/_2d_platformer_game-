import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class GreenOrb extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  GreenOrb({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(position: brickpos, anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 从图块集加载钥匙纹理
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPosition,
      srcSize: Vector2(gridSize, gridSize),
    );

    // 添加碰撞箱（可根据需要调整大小）
    add(
      RectangleHitbox(
        size: Vector2(gridSize, gridSize),
        position: Vector2(gridSize * 0.1, gridSize * 0.1),
      ),
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      final burstColor =
          (other as dynamic).color is Color
              ? (other as dynamic).color as Color
              : Colors.greenAccent;
      parent?.add(Particles.collectBurst(center.clone(), color: burstColor));
      other.charge(); // 玩家获得充能
      // 屏幕小幅震动（左右快速偏移模拟）
      final viewfinder = game.camera.viewfinder;
      // 以当前摄像机位置为本次震动原点
      final origin = viewfinder.position.clone();
      final shakeDistance = 8.0;
      final shakeDuration = 0.04;
      // 先移除所有MoveEffect，避免叠加
      viewfinder.children.whereType<MoveEffect>().toList().forEach(
        (e) => e.removeFromParent(),
      );
      // 依次添加震动效果
      viewfinder.add(
        MoveEffect.by(
          Vector2(shakeDistance, 0),
          EffectController(duration: shakeDuration),
        ),
      );
      viewfinder.add(
        MoveEffect.by(
          Vector2(-2 * shakeDistance, 0),
          EffectController(duration: shakeDuration * 2),
        ),
      );
      viewfinder.add(
        MoveEffect.by(
          Vector2(shakeDistance, 0),
          EffectController(duration: shakeDuration),
        ),
      );
      // 最后强制回归本次原点
      viewfinder.add(MoveEffect.to(origin, EffectController(duration: 0.01)));
      collectOrb();
    }
  }

  void collectOrb() {
    // 从游戏中移除绿球
    removeFromParent();
    game.removeGreenOrb(type);
  }
}
