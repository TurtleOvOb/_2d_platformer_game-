import 'package:_2d_platformergame/pages/LevelCompletePage.dart';
import 'package:_2d_platformergame/pages/GameOverPage.dart';
import 'package:_2d_platformergame/widgets/game_page/game_ui.dart';
import 'My_Game.dart';
import 'package:_2d_platformergame/Game/mission_system.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
    game.onLevelComplete = (level) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // 禁止点击外部关闭
          builder:
              (context) =>
                  LevelCompletePage(nowlevel: level, player: game.player),
        );
      }
    };

    // 设置玩家死亡回调
    game.onPlayerDeath = (level) {
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
      game.pauseEngine();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // 确保每次构建都有有效的游戏实例
    if (!isGameCreated) {
      _createNewGame();
    }

    final mission = widget.levelId != null ? missionMap[widget.levelId!] : null;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 新增背景图片层
          Image.asset(
            'assets/images/containers/BackGround4.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ClipRect(
            child: FittedBox(
              fit: BoxFit.cover, // 裁剪并铺满
              child: SizedBox(
                width: widget.pxWid.toDouble(),
                height: widget.pxHei.toDouble(),
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
            child: SafeArea(child: GameUi(game: game, mission: mission)),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: Row(
              children: [
                _buildCircleButton(
                  icon: Icons.arrow_left,
                  onTapDown: (_) {
                    _leftTimer?.cancel();
                    game.player?.moveLeft();
                    _leftTimer = Timer.periodic(
                      const Duration(milliseconds: 16),
                      (_) {
                        game.player?.moveLeft();
                      },
                    );
                  },
                  onTapUp: (_) {
                    _leftTimer?.cancel();
                    game.player?.stopHorizontal();
                  },
                  onTapCancel: () {
                    _leftTimer?.cancel();
                    game.player?.stopHorizontal();
                  },
                ),
                SizedBox(width: 30),
                _buildCircleButton(
                  icon: Icons.arrow_right,
                  onTapDown: (_) {
                    _rightTimer?.cancel();
                    game.player?.moveRight();
                    _rightTimer = Timer.periodic(
                      const Duration(milliseconds: 16),
                      (_) {
                        game.player?.moveRight();
                      },
                    );
                  },
                  onTapUp: (_) {
                    _rightTimer?.cancel();
                    game.player?.stopHorizontal();
                  },
                  onTapCancel: () {
                    _rightTimer?.cancel();
                    game.player?.stopHorizontal();
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: _buildCircleButton(
              icon: Icons.arrow_upward,
              onTapDown: (_) {
                game.player?.requestJump();
              },
              onTapUp: (_) {
                game.player?.releaseJump();
              },
              onLongPressStart: (_) {
                game.player?.requestJump();
              },
              onLongPressEnd: (_) {
                game.player?.releaseJump();
              },
            ),
          ),
          // 其他游戏UI组件可以在这里添加
        ],
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
