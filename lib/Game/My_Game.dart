import 'package:flame/camera.dart';
import 'package:_2d_platformergame/objects/Orbs/ChargedOrb.dart';
import 'package:_2d_platformergame/objects/bricks/KeyBlock.dart';
import 'package:_2d_platformergame/player/player.dart';
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
  final int? levelId;
  final int pxWid;
  final int pxHei;

  bool isPaused = false;

  MyGame({this.levelId, required this.pxWid, required this.pxHei})
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

    // 4. 重新生成砖块并获取实际关卡尺寸
    final (bricks, realWid, realHei) = await BrickGeneratorWithSize();
    // 摄像机 viewport 固定为 512x288
    camera.viewport = FixedResolutionViewport(resolution: Vector2(512, 288));
    camera.viewfinder.anchor = Anchor.center;
    // 摄像机运动模式：关卡大于画面则跟随，否则静止居中
    if (pxWid > 512 || pxHei > 288) {
      // 关卡大于画面，摄像机跟随玩家，限制边界
      camera.follow(player!);
      // 可选：限制边界，防止超出
      // 这里可根据实际 Flame 版本补充 setBounds 或 clamp 逻辑
    } else {
      // 关卡小于等于画面，摄像机静止居中
      camera.viewfinder.position = Vector2(pxWid / 2, pxHei / 2);
    }
  }

  /// 返回 (砖块列表, 关卡宽, 关卡高)
  Future<(List<PositionComponent>, int, int)> BrickGeneratorWithSize() async {
    final parser = LdtkParser();
    final levelPath = 'assets/levels/Level_${levelId! - 1}.ldtk';
    List<PositionComponent> bricks = [];
    int pxWid = 512, pxHei = 288;
    try {
      final result = await parser.parseLdtkLevelWithSize(levelPath);
      bricks = result.$1;
      pxWid = result.$2;
      pxHei = result.$3;
      for (var brick in bricks) {
        world.add(brick);
      }
    } catch (e) {
      // 如果关卡文件不存在，加载默认关卡(Level_0.ldtk)
      final result = await parser.parseLdtkLevelWithSize(
        'assets/levels/Level_0.ldtk',
      );
      final defaultBricks = result.$1;
      pxWid = result.$2;
      pxHei = result.$3;
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
    print('Camera: \${camera.viewport.resolution}, Level: \${pxWid}x\${pxHei}');
    return (bricks, pxWid, pxHei);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!isPaused) {
      // 仅在非暂停状态下处理点击事件
      player!.requestJump();
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
          player!.requestJump();
        }
      } else if (event is KeyUpEvent) {
        pressedKeys.remove(event.logicalKey);
        if (event.logicalKey == LogicalKeyboardKey.space) {
          player!.releaseJump();
        }
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
      (component) => component is KeyBlock && component.type == type,
    );
  }

  void removeGreenOrb(int type) {
    world.removeWhere(
      (component) => component is GreenOrb && component.type == type,
    );
  }
}
