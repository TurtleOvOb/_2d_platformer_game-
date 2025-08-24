import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';
import 'package:_2d_platformergame/utils/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

/// 传送门组件，根据type区分不同的传送门
/// type: 0 - 入口传送门（蓝色），1 - 出口传送门（橙色）
/// portalGroup: 传送门组标识符，只有相同组的传送门才会相互传送
/// 双向传送：任何传送门都可以传送到同组的其他传送门
class Portal extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final int VisualType; // 0表示入口传送门（蓝色），1表示出口传送门（橙色）
  final double gridSize;
  final int portalGroup; // 传送门组标识符，默认为0，相同组的传送门相互连接

  // 传送门特性参数
  bool _isActive = true; // 是否激活状态
  double _cooldownTime = 0; // 冷却时间计时器
  final double _cooldownDuration = 1.0; // 冷却时间（秒）

  Portal({
    required this.brickpos,
    required this.VisualType,
    required this.gridSize,
    this.portalGroup = 0, // 默认为组0
  }) : super(
         position: brickpos,
         anchor: Anchor.topLeft,
         size: Vector2(gridSize, gridSize * 2), // 明确设置为两格高
       );

  @override
  Future<void> onLoad() async {
    // 添加上下浮动动画
    add(
      MoveEffect.by(
        Vector2(0, -4),
        EffectController(
          duration: 0.7,
          reverseDuration: 0.7,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
    await super.onLoad();
    // 根据VisualType选择不同的srcPosition（tileset中的不同图块）
    Vector2 tileSrcPos;
    if (VisualType == 0) {
      // 蓝色传送门在tileset.png的(0,16)
      tileSrcPos = Vector2(13 * 16, 16);
    } else {
      // 橙色传送门在tileset.png的(32,16)
      tileSrcPos = Vector2(15 * 16, 16);
    }
    Sprite portalSprite = await Sprite.load(
      'tileset.png',
      srcPosition: tileSrcPos,
      srcSize: Vector2(gridSize, gridSize * 2),
    );
    animation = SpriteAnimation.spriteList(
      [portalSprite],
      stepTime: 1.0,
      loop: false,
    );
    // 添加碰撞箱 - 调整为两格高
    add(
      RectangleHitbox(
        size: Vector2(gridSize * 0.8, gridSize * 1.8),
        position: Vector2(gridSize * 0.1, gridSize * 0.1),
      ),
    );
  }

  // 用于调试的标志
  bool _debugPrinted = false;

  @override
  void update(double dt) {
    super.update(dt);

    // 更新冷却时间计时器
    if (!_isActive) {
      _cooldownTime -= dt;
      if (_cooldownTime <= 0) {
        _isActive = true;
      }
    }

    // 启动后仅打印一次动画状态，确认是否正确加载
    if (!_debugPrinted && animation != null) {
      _debugPrinted = true;
      print(
        '传送门(类型:${VisualType == 0 ? "蓝" : "橙"}) - 动画帧数: ${animation!.frames.length}, playing=${playing}',
      );
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    if (other is Player && _isActive) {
      // 任何传送门都可以触发传送（双向传送）
      // 找到其他可用的传送门
      final targetPortal = _findTargetPortal();
      if (targetPortal != null) {
        // 播放传送门特效
        _playTeleportEffect(other, isTeleporting: true);

        // 传送玩家到目标传送门
        _teleportPlayer(other, targetPortal);

        // 设置冷却
        _setCooldown();
        targetPortal._setCooldown();
      }
    }
  }

  /// 设置传送门冷却
  void _setCooldown() {
    _isActive = false;
    _cooldownTime = _cooldownDuration;
  }

  /// 查找可用的目标传送门
  Portal? _findTargetPortal() {
    // 寻找相同组的其他活跃传送门
    // 如果有多个可用传送门，优先选择不同类型的
    Portal? sameTypePortal;
    Portal? differentTypePortal;

    // 遍历世界中的所有组件
    for (final component in game.world.children) {
      if (component is Portal &&
          component != this && // 不是自己
          component._isActive && // 是活跃状态
          component.portalGroup == this.portalGroup) {
        // 必须是同一组的传送门

        if (component.VisualType == VisualType) {
          // 找到相同类型的传送门
          sameTypePortal = component;
        } else {
          // 找到不同类型的传送门
          differentTypePortal = component;
          break; // 优先使用不同类型的传送门
        }
      }
    }

    // 优先返回不同类型的传送门，如果没有则返回相同类型的
    return differentTypePortal ?? sameTypePortal;
  }

  /// 传送玩家到目标传送门
  void _teleportPlayer(Player player, Portal targetPortal) {
    // 保存玩家的速度和状态
    final playerSpeed = Vector2(player.playerspeed.x, player.playerspeed.y);

    // 计算偏移量，确保玩家出现在传送门中心位置
    // 由于传送门是两格高，玩家应该出现在下部位置
    final offsetX = targetPortal.gridSize / 2 - player.width / 2;
    final offsetY = targetPortal.gridSize * 1.5 - player.height; // 调整为出现在传送门底部

    // 设置玩家新位置（目标传送门位置 + 偏移）
    player.position.x = targetPortal.position.x + offsetX;
    player.position.y = targetPortal.position.y + offsetY;

    // 恢复玩家速度
    player.playerspeed.setFrom(playerSpeed);

    // 播放目标传送门特效
    targetPortal._playTeleportEffect(player, isTeleporting: false);
  }

  /// 播放传送特效
  void _playTeleportEffect(
    PositionComponent entity, {
    required bool isTeleporting,
  }) {
    // 选择颜色，根据传送门类型和传送状态选择合适的颜色
    Color effectColor;
    if (isTeleporting) {
      // 传送开始时使用传送门自己的颜色
      effectColor =
          VisualType == 0 ? const Color(0xFF42A5F5) : const Color(0xFFFF7043);
    } else {
      // 传送结束时使用目标点的颜色
      effectColor =
          VisualType == 0 ? const Color(0xFF42A5F5) : const Color(0xFFFF7043);
    }

    // 在传送门的中下部位置创建粒子效果（考虑到两格高的特性）
    final effectPosition = Vector2(
      position.x + gridSize / 2, // 水平居中
      position.y + gridSize * 1.5, // 在传送门下部位置
    );

    // 创建粒子爆炸效果
    parent?.add(
      Particles.teleportBurst(
        effectPosition,
        color: effectColor,
        count: 20,
        speed: 100.0,
        gravity: 50.0,
      ),
    );
  }
}
