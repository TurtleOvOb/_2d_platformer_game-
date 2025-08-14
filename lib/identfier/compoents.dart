import 'package:_2d_platformergame/objects/Specials/Key2.dart';
import 'package:_2d_platformergame/objects/Specials/face.dart';
import 'package:_2d_platformergame/objects/bricks/ChargedPlatform.dart';
import 'package:_2d_platformergame/objects/bricks/DoorBlock.dart';
import 'package:_2d_platformergame/objects/bricks/KeyBlock2.dart';
import 'package:_2d_platformergame/objects/bricks/WhiteBlock.dart';
import 'package:_2d_platformergame/objects/Specials/line.dart';
import 'package:flame/components.dart';
import '../objects/bricks/brick.dart';
import '../objects/bricks/half_brick.dart';
import '../objects/bricks/key_block1.dart';
import '../objects/Specials/key1.dart';
import '../objects/Specials/spike.dart';
import '../objects/Specials/SpawnPoint.dart';
import '../objects/Orbs/ChargedOrb.dart';

PositionComponent? createComponentForTile(
  int tileId,
  double x,
  double y,
  double offsetX,
  double offsetY,
  int tileSize, {
  void Function(Vector2)? onSpawnPoint,
}) {
  switch (tileId) {
    case 0:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0, 0),
        type: 0,
        gridSize: tileSize,
      );
    case 1:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(16, 0),
        type: 0,
        gridSize: tileSize,
      );
    case 2:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(2 * 16, 0),
        type: 0,
        gridSize: tileSize,
      );
    case 32:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0, 16),
        type: 0,
        gridSize: tileSize,
      );
    case 33:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(16, 16),
        type: 0,
        gridSize: tileSize,
      );
    case 34:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(2 * 16, 16),
        type: 0,
        gridSize: tileSize,
      );
    case 64:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0 * 16, 2 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 65:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(1 * 16, 2 * 16),
        type: 0,
        gridSize: tileSize,
      );

    case 66:
      return Brick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(2 * 16, 2 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 128:
      return HalfBrick(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0, 4 * 16),
        type: 0,
        gridSize: tileSize.floorToDouble(),
      );
    case 129:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(1 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.floorToDouble(),
      );
    case 130:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(2 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 132:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(4 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );

    case 133:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(5 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 134:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(6 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 160:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY + 8)),
        srcPosition: Vector2(0, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 162:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY + 8)),
        srcPosition: Vector2(2 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 224:
      return WhiteBlock(
        blockPos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 225:
      return WhiteBlock(
        blockPos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(1 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 226:
      return WhiteBlock(
        blockPos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(2 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 237:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(13 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 268:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(12 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 270:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(14 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 332:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(12 * 16, 10 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 364:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(12 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 396:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(12 * 16, 12 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 356:
      return KeyBlock1(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(4 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 359:
      return Key2(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(7 * 16, 11 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 388:
      return KeyBlock1(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(4 * 16, 12 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 357:
      return KeyBlock2(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(5 * 16, 11 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 389:
      return KeyBlock2(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(5 * 16, 12 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 358:
      return Key1(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(6 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 339:
      return Face(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(19 * 16, 10 * 16),
        type: 0,
        gridSize: tileSize,
      );

    case 360:
      return GreenOrb(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(8 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 361:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 362:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(10 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 363:
      return Line(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(11 * 16, 11 * 16),
        type: 0,
        gridSize: tileSize,
      );
    case 289:
      final spawnPosition = Vector2((x + offsetX), (y + offsetY));
      if (onSpawnPoint != null) {
        onSpawnPoint(spawnPosition);
      }
      return SpawnPoint(
        brickpos: spawnPosition,
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 425:
      return DoorBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 13 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 457:
      return DoorBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 14 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );

    default:
      return null;
  }
}
