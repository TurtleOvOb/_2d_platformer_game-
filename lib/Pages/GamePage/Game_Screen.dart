import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/Pages/GamePage/GameOverScreen.dart';
import 'package:_2d_platformergame/Pages/GamePage/GameUI.dart';
import 'package:_2d_platformergame/Pages/GamePage/LevelCompleteScreen.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

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
              (context) => LevelCompleteScreen(nowlevel: level, score: score),
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
          builder: (context) => GameOverScreen(nowlevel: level),
        );
      }
    };

    isGameCreated = true;
  }

  @override
  void dispose() {
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

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover, // 裁剪并铺满
              child: SizedBox(
                width: 512,
                height: 288,
                // 使用key来确保每次构建都刷新GameWidget
                child: GameWidget.controlled(
                  gameFactory: () => game,
                  key: ValueKey(
                    'game-${widget.levelId}-${DateTime.now().millisecondsSinceEpoch}',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: GameUi()),
          ),
          // 其他游戏UI组件可以在这里添加
        ],
      ),
    );
  }
}
