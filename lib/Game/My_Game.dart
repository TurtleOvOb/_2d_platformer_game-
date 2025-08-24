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
  // 死区参数
  final double deadzoneWidth = 512 / 8;
  final double deadzoneHeight = 288 / 8;
  bool useDeadzone = false;
  Player? player; // 移除 late 关键字，允许为 null
  final Set<LogicalKeyboardKey> pressedKeys = {};
  final int? levelId;
  final int pxWid;
  final int pxHei;

  bool isPaused = false;
  bool isInitialized = false; // 添加标志跟踪初始化状态

  MyGame({this.levelId, required this.pxWid, required this.pxHei})
    : super(
        camera: CameraComponent.withFixedResolution(width: 512, height: 288),
      );

  @override
  Color backgroundColor() => const Color(0xFFFFC300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 添加背景图片精灵到world底层
    final bg =
        SpriteComponent()
          ..sprite = await Sprite.load('containers/BackGround4.png')
          ..size = Vector2(512, 288)
          ..anchor = Anchor.topLeft
          ..position = Vector2.zero()
          ..priority = -100;
    world.add(bg);
    initial(); // 添加初始调用
  }

  void onMount() {
    super.onMount();
    //debugMode = true;
  }

  Future<void> initial() async {
    try {
      // 2. 重新创建玩家
      player = Player(spawnPosition: Vector2(16, 144));
      world.add(player!);

      // 4. 重新生成砖块并获取实际关卡尺寸
      final result = await BrickGeneratorWithSize();
      final int levelWidth = result.$2;
      final int levelHeight = result.$3;

      // 嵌合相机viewport分辨率逻辑
      if (pxWid > 600 && player != null) {
        // 关卡大于画面，摄像机分辨率固定为512x288，手动实现死区跟随
        camera.viewport = FixedResolutionViewport(
          resolution: Vector2(512, 288),
        );
        camera.viewfinder.anchor = Anchor.center;
        useDeadzone = true;
        // 摄像机初始居中
        camera.viewfinder.position = player!.position.clone();
        print('当前摄影机大小: 512 x 288 (固定)');
      } else {
        // 关卡小于等于画面，摄像机分辨率等于关卡大小，静止居中
        camera.viewport = FixedResolutionViewport(
          resolution: Vector2(levelWidth.toDouble(), levelHeight.toDouble()),
        );
        camera.viewfinder.anchor = Anchor.center;
        camera.viewfinder.position = Vector2(levelWidth / 2, levelHeight / 2);
        useDeadzone = false;
        print('当前摄影机大小: \\${levelWidth} x \\${levelHeight} (自适应关卡)');
      }

      // 初始化完成
      isInitialized = true;
      print('游戏初始化完成');
    } catch (e) {
      print('游戏初始化失败: $e');
      // 在初始化失败的情况下，确保标记游戏未初始化
      isInitialized = false;
    }
  }

  /// 返回 (砖块列表, 关卡宽, 关卡高)
  Future<(List<PositionComponent>, int, int)> BrickGeneratorWithSize() async {
    final parser = LdtkParser();
    final levelPath = 'assets/levels/Level_${levelId!}.ldtk';
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
    if (parser.spawnPointPosition != null && player != null) {
      player!.spawnPosition = parser.spawnPointPosition!;
      player!.position = parser.spawnPointPosition!;
      print('设置玩家出生点: ${parser.spawnPointPosition!}');
    } else {
      print(
        '无法设置玩家出生点: ${player == null ? "player为null" : "spawnPosition为null"}',
      );
    }

    return (bricks, pxWid, pxHei);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!isPaused && isInitialized && player != null) {
      // 仅在非暂停状态、初始化完成且玩家存在的情况下处理点击事件
      player!.requestJump();
    }
  }

  @override
  void update(double dt) {
    if (!isPaused && isInitialized && player != null) {
      // 仅在非暂停状态且初始化完成且玩家存在的情况下更新游戏
      super.update(dt);
      if (pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
        player!.moveLeft();
      } else if (pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
        player!.moveRight();
      } else {
        player!.stopHorizontal();
      }

      // 手动实现摄像机死区机制
      if (useDeadzone) {
        final camPos = camera.viewfinder.position;
        final playerPos = player!.position;
        final left = camPos.x - deadzoneWidth / 2;
        final right = camPos.x + deadzoneWidth / 2;
        final top = camPos.y - deadzoneHeight / 2;
        final bottom = camPos.y + deadzoneHeight / 2;
        double newCamX = camPos.x;
        double newCamY = camPos.y;
        if (playerPos.x < left) {
          newCamX = playerPos.x + deadzoneWidth / 2;
        } else if (playerPos.x > right) {
          newCamX = playerPos.x - deadzoneWidth / 2;
        }
        if (playerPos.y < top) {
          newCamY = playerPos.y + deadzoneHeight / 2;
        } else if (playerPos.y > bottom) {
          newCamY = playerPos.y - deadzoneHeight / 2;
        }
        camera.viewfinder.position = Vector2(newCamX, newCamY);
      }

      // 检测玩家是否超出屏幕边界
      if (_isPlayerOutOfScreen()) {
        playerDeath();
      }
    } else {
      // 仍然调用super.update确保游戏引擎正常运行
      super.update(dt);
    }
  }

  // 检测玩家是否超出屏幕外
  bool _isPlayerOutOfScreen() {
    if (player == null) return false;
    final px = player!.position.x;
    final py = player!.position.y;
    final sx = player!.size.x;
    final sy = player!.size.y;
    // 判定条件可根据实际关卡尺寸调整
    if (px + sx < 0 || px > pxWid || py + sy < 0 || py > pxHei) {
      return true;
    }
    return false;
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!isPaused && isInitialized && player != null) {
      // 仅在非暂停状态、初始化完成且玩家存在的情况下处理键盘事件
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
    if (type == 0 || type == 2) {
      world.removeWhere(
        (component) =>
            component is KeyBlock &&
            (component.type == 0 || component.type == 2),
      );
    } else if (type == 1 || type == 3) {
      world.removeWhere(
        (component) =>
            component is KeyBlock &&
            (component.type == 1 || component.type == 3),
      );
    }
  }

  void removeGreenOrb(int type) {
    world.removeWhere(
      (component) => component is GreenOrb && component.type == type,
    );
  }

  // 事件回调通知
  Function(int level)? onLevelComplete;
  Function(int level)? onPlayerDeath;

  // 添加通关方法 - 不再处理页面跳转
  void endLevel() {
    try {
      // 暂停游戏
      pauseGame();
      // 获取当前分数（如果有需要可以计算）
      final currentLevel = levelId ?? 1; // 保存当前关卡ID
      if (overlays.isActive('gameUI')) {
        overlays.remove('gameUI');
      }

      if (onLevelComplete != null) {
        onLevelComplete!(currentLevel);
      }
    } catch (e) {
      print('执行endLevel方法时发生错误: $e');
    }
  }

  // 添加玩家死亡方法
  void playerDeath() {
    try {
      // 暂停游戏
      pauseGame();

      final currentLevel = levelId ?? 1; // 保存当前关卡ID

      if (overlays.isActive('gameUI')) {
        overlays.remove('gameUI'); // 移除游戏UI（如果有）
      }
      // 触发回调而不是直接导航
      if (onPlayerDeath != null) {
        onPlayerDeath!(currentLevel);
      }
    } catch (e) {
      print('执行playerDeath方法时发生错误: $e');
    }
  }

  // 计算游戏得分的方法（可以根据实际需求自定义计分逻辑）
}
