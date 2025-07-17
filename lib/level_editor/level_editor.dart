import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:_2d_platformergame/bricks/brick.dart';

class LevelEditorGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  final List<Brick> bricks = [];
  late final CameraComponent cameraComponent;
  @override
  late final World world;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 初始化 World 组件
    world = World();
    add(world);
    // 初始化 CameraComponent 实例
    cameraComponent = CameraComponent(world: world);
    add(cameraComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // 使用 camera.viewport.globalToLocal 将屏幕坐标转换为游戏世界坐标
    final worldPosition = cameraComponent.viewport.globalToLocal(
      event.canvasPosition,
    );
    print('点击位置（屏幕坐标）: ${event.canvasPosition}');
    print('转换后的游戏世界坐标: $worldPosition');
    final brick = Brick(brickpos: worldPosition);
    world.add(brick);
    bricks.add(brick);
    print('Brick 添加位置（游戏世界坐标）: ${brick.position}');
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
