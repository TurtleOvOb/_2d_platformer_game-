import 'package:_2d_platformergame/pages/LevelCompletePage.dart';
import 'package:_2d_platformergame/pages/GameOverPage.dart';
import 'package:_2d_platformergame/widgets/game_page/game_ui.dart';
import 'package:_2d_platformergame/Game/mission_system.dart';
import 'My_Game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// 使用自定义的GameUI组件，移除不再需要的PauseOverlay

// 新增：游戏界面组件

class GameScreen extends StatefulWidget {
  final int? levelId;
  final int pxWid;
  final int pxHei;

  const GameScreen({
    super.key,
    this.levelId,
    required this.pxWid,
    required this.pxHei,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  Timer? _leftTimer;
  Timer? _rightTimer;
  // 注意：不使用late final，而是使用普通变量
  late MyGame game;
  bool isGameCreated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 每次初始化时创建一个全新的游戏实例
    _createNewGame();
  }

  // 创建新游戏实例的方法
  void _createNewGame() {
    // 确保之前的游戏实例被正确清理
    if (isGameCreated) {
      game.pauseEngine();
    }

    // 初始化游戏
    game = MyGame(
      levelId: widget.levelId,
      pxWid: widget.pxWid,
      pxHei: widget.pxHei,
    );

    // 设置游戏通关回调
    game.onLevelComplete = (level, score) {
      // 显示通关对话框覆盖层
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // 禁止点击外部关闭
          builder:
              (context) => LevelCompletePage(nowlevel: level, score: score),
        );
      }
    };

    // 设置玩家死亡回调
    game.onPlayerDeath = (level) {
      // 显示游戏结束对话框覆盖层
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // 禁止点击外部关闭
          builder: (context) => GameOverPage(nowlevel: level),
        );
      }
    };

    isGameCreated = true;
  }

  @override
  void dispose() {
    _leftTimer?.cancel();
    _rightTimer?.cancel();
    // 在销毁 widget 时正确清理游戏实例
    if (isGameCreated) {
      // 确保游戏引擎停止
      game.pauseEngine();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 不再需要设置 context
  }

  // 不再需要显示暂停对话框的方法，由GameUI组件处理

  @override
  Widget build(BuildContext context) {
    // 确保每次构建都有有效的游戏实例
    if (!isGameCreated) {
      _createNewGame();
    }

    // 关卡任务表
    final Map<int, Mission> missionMap = {
      1: Mission(maxTime: 60, maxDeath: 3, minCollectibles: 2),
      2: Mission(maxTime: 80, maxDeath: 2, minCollectibles: 3),
      3: Mission(maxTime: 100, maxDeath: 1, minCollectibles: 4),
      // 可继续添加更多关卡
    };
    final mission = missionMap[widget.levelId ?? 1];

    print('GameScreen game.player: ${game.player}');

      return Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameUi': (context, game) => SafeArea(child: GameUi(mission: mission, game: game as MyGame)),
          },
          initialActiveOverlays: const ['GameUi'],
        ),
      );
  }

  // 构建圆形半透明按钮
  Widget _buildCircleButton({
    required IconData icon,
    VoidCallback? onPressed,
    GestureTapDownCallback? onTapDown,
    GestureTapUpCallback? onTapUp,
    VoidCallback? onTapCancel,
    GestureLongPressStartCallback? onLongPressStart,
    GestureLongPressEndCallback? onLongPressEnd,
  }) {
    return GestureDetector(
      onTap: onPressed,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 3),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 36),
      ),
    );
  }
}
