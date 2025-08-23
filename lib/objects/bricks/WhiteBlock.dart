import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../player/player.dart';
import 'package:_2d_platformergame/utils/particles.dart';

class WhiteBlock extends SpriteComponent with CollisionCallbacks {
  Color color;
  final Vector2 blockPos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;
  bool isCharged = false; // 是否为充能块
  static const double jumpBoostMultiplier = 1.5;
  double? _originalJumpSpeed;

  WhiteBlock({
    required this.blockPos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
    this.color = Colors.white,
  }) {
    position = Vector2(blockPos.x.floorToDouble(), blockPos.y.floorToDouble());
    size = Vector2.all(gridSize.floorToDouble()); // 与Brick完全一致，避免缝隙
    anchor = Anchor.topLeft;
    if (type == 1) {
      isCharged = true;
    } else {
      isCharged = false;
    }
  }

  Sprite? normalSprite;
  Sprite? chargedSprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    normalSprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble(),
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2.all(gridSize.floorToDouble()),
    );

    chargedSprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble() + 6 * gridSize,
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2.all(gridSize.floorToDouble()),
    );

    sprite = normalSprite;
    // RectangleHitbox大小与Brick一致，都是gridSize.floorToDouble()
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2.all(gridSize.floorToDouble()),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    // 渲染优先级：充能块 > 染色块 > 普通白块
    if (isCharged && chargedSprite != null) {
      chargedSprite!.render(canvas, size: size);
    } else if (normalSprite != null) {
      normalSprite!.render(canvas, size: size);
    } else {
      super.render(canvas);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Player) {
      // 玩家充能状态下，站上白块转为充能块
      if (other.isCharged && !isCharged) {
        _chargeConnectedBlocks();
        other.discharge(); // 玩家消耗充能
      }
      // 原有吸收颜色逻辑
      else if (other.color != Colors.white && !isCharged) {
        parent?.add(Particles.collectBurst(center.clone(), color: other.color));
        color = other.color;
        other.color = Colors.white;
      }

      // 充能块：提升玩家跳跃高度（仿照ChargedPlatform）
      if (isCharged) {
        final playerBottom = other.position.y + other.size.y;
        final blockTop = position.y;
        // 只在玩家未被其他充能块提升时才提升跳跃速度
        if (playerBottom <= blockTop + 10 && other.jumpSpeed <= 250.0 + 1) {
          if (_originalJumpSpeed == null) {
            _originalJumpSpeed = other.jumpSpeed;
            other.jumpSpeed = _originalJumpSpeed! * jumpBoostMultiplier;
          }
        }
      }
    }
  }

  // 连锁充能：递归将所有相邻白块变为充能块
  void _chargeConnectedBlocks([Set<WhiteBlock>? visited]) {
    visited ??= <WhiteBlock>{};
    if (visited.contains(this)) return;
    visited.add(this);
    if (!isCharged) {
      isCharged = true;
      sprite = chargedSprite ?? sprite;
      parent?.add(
        Particles.collectBurst(center.clone(), color: Colors.lightBlueAccent),
      );
    }
    // 查找上下左右相邻的白块
    final neighbors = _findNeighborWhiteBlocks();
    for (final block in neighbors) {
      block._chargeConnectedBlocks(visited);
    }
  }

  // 查找上下左右相邻的白块
  List<WhiteBlock> _findNeighborWhiteBlocks() {
    final List<WhiteBlock> result = [];
    if (parent == null) return result;
    for (final c in parent!.children) {
      if (c is WhiteBlock && !c.isCharged) {
        final dx = (c.position.x - position.x).abs();
        final dy = (c.position.y - position.y).abs();
        if ((dx == gridSize && dy == 0) || (dx == 0 && dy == gridSize)) {
          result.add(c);
        }
      }
    }
    return result;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is Player && _originalJumpSpeed != null) {
      // 只有当玩家离开所有充能块时才恢复跳跃速度
      bool stillOnChargedBlock = false;
      if (parent != null) {
        for (final c in parent!.children) {
          if (c is WhiteBlock && c != this && c.isCharged) {
            final dx = (c.position.x - other.position.x).abs();
            final dy =
                (c.position.y - (other.position.y + other.size.y - gridSize))
                    .abs();
            if ((dx == 0 && dy < 1) || (dy == 0 && dx < 1)) {
              stillOnChargedBlock = true;
              break;
            }
          }
        }
      }
      if (!stillOnChargedBlock) {
        other.jumpSpeed = _originalJumpSpeed!;
      }
      _originalJumpSpeed = null;
    }
  }

  // 判断是否为充能块
  bool get isChargedBlock => isCharged;
}
