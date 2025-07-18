import 'dart:convert';
import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:_2d_platformergame/bricks/brick.dart';
import 'package:flutter/material.dart';

class LevelEditorGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  final List<Brick> bricks = [];
  late final CameraComponent cameraComponent;

  @override
  Color backgroundColor() => Color(0xFFFFC300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 初始化 CameraComponent 实例
    cameraComponent = CameraComponent(world: world);
    add(cameraComponent);
    debugMode = true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // 获取设备点击位置
    final screenPosition = event.devicePosition;

    // 转化为世界坐标
    final worldPosition = cameraComponent.viewport.globalToLocal(
      screenPosition,
    );

    final brickSize = Vector2(50, 50);
    //对齐方块
    final alignedPosition = Vector2(
      (worldPosition.x / brickSize.x).floor() * brickSize.x,
      (worldPosition.y / brickSize.y).floor() * brickSize.y,
    );
    final brick = Brick(brickpos: alignedPosition);
    world.add(brick);
    bricks.add(brick);
  }

  String exportLevelToJson() {
    final levelData = {
      'bricks':
          bricks.map((brick) {
            return {
              'size': [brick.bricksize.x, brick.bricksize.y],
              'position': [brick.position.x, brick.position.y],
            };
          }).toList(),
    };
    return jsonEncode(levelData);
  }
}
