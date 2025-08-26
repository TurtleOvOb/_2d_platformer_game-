import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:flame/effects.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flutter/material.dart';

/// 钥匙块类，根据type参数决定需要哪种钥匙来开启
/// type: 0，2 - 需要Key1开启
/// type: 1 ，4- 需要Key2开启

class KeyBlock extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  /// 钥匙块爆炸消失动画
  void playUnlockAnimation() {
    // 取中心点
    final center = absoluteCenter;
    // 颜色根据钥匙类型区分
    final color = Colors.white;
    parent?.add(
      Particles.collectBurst(
        center.clone(),
        color: color,
        count: 22,
        lifespan: 0.55,
        speed: 170,
      ),
    );
    removeFromParent();
  }

  final Vector2 brickpos;
  final int type; // 0:实心 1:空心 2:横实心 3:横空心
  final double gridSize;

  KeyBlock({
    required this.brickpos,
    required this.type,
    required this.gridSize,
  }) {
    position = brickpos;
    if (type == 2 || type == 3) {
      // 横向keyblock
      size = Vector2(gridSize * 2, gridSize);
    } else {
      // 竖向keyblock
      size = Vector2(gridSize, gridSize * 2);
    }
  }

  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;
  late Sprite keySprite;
  bool isCollected = false;

  /// 返回钥匙类型的描述
  String get keyTypeName {
    if (type == 0 || type == 2) return "黄钥匙";
    return "蓝钥匙";
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // 根据type自动选择贴图区域
    Vector2 spriteSize =
        (type == 2 || type == 3)
            ? Vector2(gridSize * 2, gridSize)
            : Vector2(gridSize, gridSize * 2);
    Vector2 srcPos;
    // 这里假设tileset中：
    // 竖黄(0): (0,0) 竖蓝(1): (16,0) 横黄(2): (0,16) 横蓝(3): (32,16)
    if (type == 0) {
      srcPos = Vector2(4 * 16, 11 * 16);
    } else if (type == 1) {
      srcPos = Vector2(5 * 16, 11 * 16);
    } else if (type == 2) {
      srcPos = Vector2(4 * 16, 13 * 16);
    } else {
      srcPos = Vector2(6 * 16, 13 * 16);
    }
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: srcPos,
      srcSize: spriteSize,
    );
    add(
      RectangleHitbox(collisionType: CollisionType.passive, size: spriteSize),
    );
  }
}
