import 'dart:ui';

import 'package:_2d_platformergame/Objects/bricks/brick.dart';
import 'package:flame/game.dart';

/// 隐形方块：继承自Brick，碰撞完全一致但不可见
class InvisibleBlock extends Brick {
  InvisibleBlock({
    required Vector2 blockPos,
    required Vector2 srcPosition,
    required int type,
    required int gridSize,
  }) : super(
         brickpos: blockPos,
         srcPosition: srcPosition,
         type: type,
         gridSize: gridSize,
       );

  @override
  void render(Canvas canvas) {
    // 不渲染任何内容，实现完全隐形
  }
}
