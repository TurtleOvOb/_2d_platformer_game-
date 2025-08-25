import 'package:_2d_platformergame/player/player.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// DashArrow 是一个特殊物品，玩家拾取后立即朝箭头方向冲刺
class DashArrow extends SpriteComponent with CollisionCallbacks {
  // 冲刺物品的基本参数
  final Vector2 brickpos; // 图块位置
  final int type;
  final double gridSize; // 网格大小
  final int dashDirection; // 冲刺方向: 1=右, -1=左, 2=上, -2=下

  double get dashPower => type == 1 ? 320.0 : 250.0; // type=1冲刺更远
  double get dashDuration => 0.3; // 可根据type扩展

  // 视觉效果参数
  bool _collected = false;
  late ColorEffect _pulseEffect;

  // 构造函数，使用与其他图块一致的构造方法
  DashArrow({
    required this.brickpos,
    required this.type,
    required this.gridSize,
    required this.dashDirection,
  }) : super(size: Vector2(gridSize.toDouble(), gridSize.toDouble())) {
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 设置位置
    position = Vector2(brickpos.x.floorToDouble(), brickpos.y.floorToDouble());

    // 根据type和dashDirection自动决定贴图坐标
    Vector2 arrowSrcPos = Vector2(48, 0); // 默认右箭头
    if (type == 0) {
      // type=1为特殊大箭头，假设tileset中不同方向有不同图块
      if (dashDirection == 1) {
        arrowSrcPos = Vector2(8 * 16, 16); // 右大箭头
      } else if (dashDirection == -1) {
        arrowSrcPos = Vector2(6 * 16, 16); // 左大箭头
      } else if (dashDirection == 2) {
        arrowSrcPos = Vector2(7 * 16, 0); // 上大箭头
      } else if (dashDirection == -2) {
        arrowSrcPos = Vector2(7 * 16, 2 * 16); // 下大箭头
      }
    } else {
      // type=0普通箭头，假设tileset中右箭头在(48,0)，左(32,0)，上(48,16)，下(32,16)
      if (dashDirection == 1) {
        arrowSrcPos = Vector2(11 * 16, 16); // 右
      } else if (dashDirection == -1) {
        arrowSrcPos = Vector2(9 * 16, 16); // 左
      } else if (dashDirection == 2) {
        arrowSrcPos = Vector2(10 * 16, 0); // 上
      } else if (dashDirection == -2) {
        arrowSrcPos = Vector2(10 * 16, 2 * 16); // 下
      } else {
        arrowSrcPos = Vector2(48, 0); // 默认右
      }
    }
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: arrowSrcPos,
      srcSize: Vector2.all(gridSize.floorToDouble()),
    );

    // 添加碰撞检测
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(gridSize.floorToDouble()),
      ),
    );

    // 添加悬浮动画效果
    add(
      MoveEffect.by(
        Vector2(0, -4),
        EffectController(
          duration: 1,
          reverseDuration: 1,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );

    // 添加颜色脉冲效果
    _pulseEffect = ColorEffect(
      const Color.fromARGB(255, 255, 255, 255), // 青色
      EffectController(duration: 0.5, reverseDuration: 0.5, infinite: true),
    );
    add(_pulseEffect);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // 检测是否与玩家碰撞
    if (!_collected && other is Player) {
      _collected = true;

      // 直接执行冲刺，无需等待跳跃或检查状态
      _performDash(other);

      // 获取箭头中心位置用于粒子效果
      final centerPos = Vector2(
        position.x + size.x / 2,
        position.y + size.y / 2,
      );

      // 添加爆破粒子效果到父组件
      parent?.add(
        Particles.collectBurst(
          centerPos,
          color: Colors.cyan, // 青色爆炸，与箭头颜色一致
          count: 24, // 更多粒子
          lifespan: 0.5, // 更短的生命周期，使效果更快
          speed: 180, // 更快的速度，爆炸感更强
        ),
      );

      // 立即移除自身，不需要淡出动画
      removeFromParent();
    }
  }

  // 执行冲刺动作
  void _performDash(Player player) {
    // 直接使用预设的方向
    int direction = dashDirection;

    // 设置玩家为冲刺状态（减弱重力影响）
    player.isDashing = true;

    // type=1时冲刺距离更大
    double power = dashPower;

    // 根据方向设置冲刺速度
    if (direction.abs() == 1) {
      // 水平冲刺 (1=右, -1=左)
      player.playerspeed.x = direction * power;
      player.playerspeed.y = 0; // 取消垂直速度
    } else if (direction.abs() == 2) {
      // 垂直冲刺 (2=上, -2=下)
      player.playerspeed.x = 0; // 取消水平速度
      player.playerspeed.y =
          -1 *
          (direction / direction.abs()) *
          power; // 确保 2 = 上 (负值), -2 = 下 (正值)
    }

    // 添加冲刺视觉效果
    _addDashEffect(
      player,
      direction.abs() == 1 ? direction : (player.scale.x > 0 ? 1 : -1),
    );

    // 冲刺结束后恢复正常物理行为
    Future.delayed(Duration(milliseconds: (dashDuration * 1000).toInt()), () {
      if (player.parent != null) {
        // 确保玩家组件还存在
        // 结束冲刺状态（恢复正常重力）
        player.isDashing = false;

        if (direction.abs() == 1) {
          // 水平冲刺结束后减速
          player.playerspeed.x *= 0.5;
        } else if (direction.abs() == 2) {
          // 垂直冲刺结束后减速
          player.playerspeed.y *= 0.5;
        }
      }
    });
  }

  // 添加冲刺视觉效果
  void _addDashEffect(Player player, int direction) {
    // 创建一个简单的拖尾效果
    for (int i = 1; i <= 3; i++) {
      // 在玩家位置创建一个发光矩形，延迟时间不同
      Future.delayed(Duration(milliseconds: 50 * i), () {
        if (player.parent == null) return;

        final afterImage = RectangleComponent(
          position: Vector2(player.position.x, player.position.y),
          size: player.size,
          anchor: player.anchor,
          paint:
              Paint()
                ..color = const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(1 - i * 0.1), // 透明度递减
        );

        afterImage.scale.x = direction < 0 ? -1.0 : 1.0;

        afterImage.add(
          OpacityEffect.fadeOut(
            EffectController(duration: 0.2),
            onComplete: () => afterImage.removeFromParent(),
          ),
        );

        player.parent?.add(afterImage);
      });
    }
  }
}
