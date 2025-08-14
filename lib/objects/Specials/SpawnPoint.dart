import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';

class SpawnPoint extends PositionComponent with HasGameReference<MyGame> {
  final Vector2 brickpos;
  final int type;
  final double gridSize;

  SpawnPoint({
    required this.brickpos,
    required this.type,
    required this.gridSize,
  }) {
    position = brickpos;
    size = Vector2(gridSize, gridSize);
  }
}
