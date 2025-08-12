import 'package:_2d_platformergame/objects/Orbs/ChargedOrb.dart';
import 'package:_2d_platformergame/objects/bricks/key_block1.dart';
import 'package:_2d_platformergame/objects/bricks/KeyBlock2.dart';

import 'package:_2d_platformergame/player/player.dart';
import 'package:flame/camera.dart';

import '../identfier/ldtk_parser.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, KeyboardEvents {
  late Player? player;
  final Set<LogicalKeyboardKey> pressedKeys = {};
  final int? levelId; // 添加关卡ID属性(可选)

  bool isPaused = false; // 新增：暂停状态

  MyGame({this.levelId}) // 修改构造函数
    : super(
        camera: CameraComponent.withFixedResolution(width: 512, height: 288),
      );

  @override
  Color backgroundColor() => const Color(0xFFFFC300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    initial(); // 添加初始调用
  }

  void onMount() {
    super.onMount();
    //debugMode = true;
  }

  Future<void> initial() async {
    // 2. 重新创建玩家
    world.add(player = Player(spawnPosition: Vector2(16, 144)));

    // 3. 重置相机
    camera.viewfinder.position = Vector2(16 * 16, 9 * 16);
    //camera.follow(player!);

    // 4. 重新生成砖块
    await BrickGenerator();
  }

  Future<List<PositionComponent>> BrickGenerator() async {
    final parser = LdtkParser();
    // 根据关卡ID加载对应的LDtk文件，关卡ID比LDtk编号大一

    final levelPath = 'assets/levels/Level_${levelId! - 1}.ldtk';
    List<PositionComponent> bricks = [];
    try {
      bricks = await parser.parseLdtkLevel(levelPath);
      for (var brick in bricks) {
        world.add(brick);
      }
    } catch (e) {
      // 如果关卡文件不存在，加载默认关卡(Level_0.ldtk)

      final defaultBricks = await parser.parseLdtkLevel(
        'assets/levels/Level_0.ldtk',
      );
      for (var brick in defaultBricks) {
        world.add(brick);
      }
      bricks = defaultBricks;
    }

    // 设置玩家出生点
    if (parser.spawnPointPosition != null) {
      player!.spawnPosition = parser.spawnPointPosition!;
      player!.position = parser.spawnPointPosition!;
    }

    print('Player spawn: ${player?.position}');

    return bricks;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!isPaused) {
      // 仅在非暂停状态下处理点击事件
      player!.jump();
    }
  }

  @override
  void update(double dt) {
    if (!isPaused) {
      // 仅在非暂停状态下更新游戏
      super.update(dt);
      if (pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
        player!.moveLeft();
      } else if (pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
        player!.moveRight();
      } else {
        player!.stopHorizontal();
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!isPaused) {
      // 仅在非暂停状态下处理键盘事件
      if (event is KeyDownEvent) {
        pressedKeys.add(event.logicalKey);
        if (event.logicalKey == LogicalKeyboardKey.space) {
          player!.jump();
        }
      } else if (event is KeyUpEvent) {
        pressedKeys.remove(event.logicalKey);
      }
    }
    return KeyEventResult.handled;
  }

  // 新增：暂停游戏方法
  void pauseGame() {
    isPaused = true;
    pauseEngine();
  }

  // 新增：继续游戏方法
  void resumeGame() {
    isPaused = false;
    resumeEngine();
  }

  // 新增：重置游戏方法
  void resetLevel() {
    // 1. 移除所有游戏对象
    world.removeAll(world.children);
    pressedKeys.clear();
    // 2. 移除玩家
    if (player != null) {
      player!.removeFromParent();
      player = null;
    }
    // 2. 重新初始化游戏
    initial();
  }

  void removeKeyBlock(int type) {
    world.removeWhere(
      (component) =>
          (component is KeyBlock1 && component.type == type) ||
          (component is KeyBlock2 && component.type == type),
    );
  }

  void removeGreenOrb(int type) {
    world.removeWhere(
      (component) => component is GreenOrb && component.type == type,
    );
  }
}
