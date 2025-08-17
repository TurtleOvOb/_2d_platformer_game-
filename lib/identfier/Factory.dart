import 'package:_2d_platformergame/Objects/Specials/ConveyorBelt.dart';
import 'package:_2d_platformergame/Objects/Specials/DashArrow.dart';
import 'package:_2d_platformergame/Objects/Specials/Key.dart';
import 'package:_2d_platformergame/Objects/Specials/Portal.dart';
import 'package:_2d_platformergame/Objects/Specials/face.dart';
import 'package:_2d_platformergame/Objects/bricks/ChargedPlatform.dart';
import 'package:_2d_platformergame/Objects/bricks/DoorBlock.dart';
import 'package:_2d_platformergame/Objects/bricks/KeyBlock.dart';
import 'package:_2d_platformergame/Objects/bricks/WhiteBlock.dart';
import 'package:_2d_platformergame/Objects/Specials/line.dart';
import 'package:flame/components.dart';
import '../Objects/bricks/brick.dart';
import '../Objects/bricks/half_brick.dart';
import '../Objects/Specials/spike.dart';
import '../Objects/Specials/SpawnPoint.dart';
import '../Objects/Orbs/ChargedOrb.dart';

PositionComponent? createComponentForTile(
  int tileId,
  double x,
  double y,
  double offsetX,
  double offsetY,
  int tileSize, {
  void Function(Vector2)? onSpawnPoint,
}) {
  // 1. 砖块类映射表
  const brickTiles = {
    0: [0, 0],
    1: [16, 0],
    2: [32, 0],
    32: [0, 16],
    33: [16, 16],
    34: [32, 16],
    64: [0, 32],
    65: [16, 32],
    66: [32, 32],
  };
  if (brickTiles.containsKey(tileId)) {
    final pos = brickTiles[tileId]!;
    return Brick(
      brickpos: Vector2(
        (x + offsetX).floorToDouble(),
        (y + offsetY).floorToDouble(),
      ),
      srcPosition: Vector2(pos[0].toDouble(), pos[1].toDouble()),
      type: 0,
      gridSize: tileSize,
    );
  }

  // 2. DashArrow
  const dashArrowTiles = {
    7: [7 * 16, 0, 2],
    38: [6 * 16, 16, -1],
    40: [8 * 16, 16, 1],
    71: [7 * 16, 2 * 16, -2],
  };
  if (dashArrowTiles.containsKey(tileId)) {
    final arr = dashArrowTiles[tileId]!;
    return DashArrow(
      brickpos: Vector2(
        (x + offsetX).floorToDouble(),
        (y + offsetY).floorToDouble(),
      ),
      srcPosition: Vector2(arr[0].toDouble(), arr[1].toDouble()),
      type: 0,
      gridSize: tileSize.toDouble(),
      dashDirection: arr[2],
    );
  }

  // 3. HalfBrick
  const halfBrickTiles = {
    128: [0, 4 * 16],
    129: [1 * 16, 4 * 16],
    130: [2 * 16, 4 * 16],
    160: [0, 4 * 16],
    162: [2 * 16, 4 * 16],
  };
  if (halfBrickTiles.containsKey(tileId)) {
    final pos = halfBrickTiles[tileId]!;
    final yOffset = (tileId == 160 || tileId == 162) ? 8 : 0;
    return HalfBrick(
      brickpos: Vector2((x + offsetX), (y + offsetY + yOffset)),
      srcPosition: Vector2(pos[0].toDouble(), pos[1].toDouble()),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }

  // 4. Spike
  const spikeTiles = {
    132: [4 * 16, 4 * 16],
    133: [5 * 16, 4 * 16],
    134: [6 * 16, 4 * 16],
  };
  if (spikeTiles.containsKey(tileId)) {
    final pos = spikeTiles[tileId]!;
    return Spike(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(pos[0].toDouble(), pos[1].toDouble()),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }

  // 5. Portal
  if (tileId == 45 || tileId == 47) {
    return Portal(
      brickpos: Vector2(
        (x + offsetX).floorToDouble(),
        (y + offsetY).floorToDouble(),
      ),
      srcPosition: Vector2((tileId == 45 ? 13 : 15) * 16, 1 * 16),
      VisualType: tileId == 45 ? 0 : 1,
      portalGroup: 1,
      gridSize: tileSize.toDouble(),
    );
  }

  // 6. ConveyorBelt
  if (tileId == 139 || tileId == 171) {
    return ConveyorBelt(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(11 * 16, tileId == 139 ? 4 * 16 : 5 * 16),
      type: 0,
      gridSize: tileSize.toDouble(),
      beltDirection: tileId == 139 ? 1 : -1,
    );
  }

  // 7. WhiteBlock
  const whiteBlockTiles = {
    224: [0, 7 * 16],
    225: [1 * 16, 7 * 16],
    226: [2 * 16, 7 * 16],
  };
  if (whiteBlockTiles.containsKey(tileId)) {
    final pos = whiteBlockTiles[tileId]!;
    return WhiteBlock(
      blockPos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(pos[0].toDouble(), pos[1].toDouble()),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }

  // 8. ChargedPlatform
  const chargedPlatformTiles = {
    237: [13 * 16, 7 * 16, 8],
    268: [12 * 16, 7 * 16, 8],
    270: [14 * 16, 7 * 16, 0],
  };
  if (chargedPlatformTiles.containsKey(tileId)) {
    final arr = chargedPlatformTiles[tileId]!;
    return ChargedPlatform(
      brickpos: Vector2(x + offsetX, y + offsetY + arr[2]),
      srcPosition: Vector2(arr[0].toDouble(), arr[1].toDouble()),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }

  // 9. KeyBlock/Key
  const keyBlockTiles = {
    356: [4 * 16, 11 * 16, 0],
    388: [4 * 16, 12 * 16, 0],
    357: [5 * 16, 11 * 16, 1],
    389: [5 * 16, 12 * 16, 1],
  };
  if (keyBlockTiles.containsKey(tileId)) {
    final arr = keyBlockTiles[tileId]!;
    return KeyBlock(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(arr[0].toDouble(), arr[1].toDouble()),
      type: arr[2],
      gridSize: tileSize.toDouble(),
    );
  }
  if (tileId == 359) {
    return Key(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(7 * 16, 11 * 16),
      type: 1,
      gridSize: tileSize.toDouble(),
    );
  }
  if (tileId == 358) {
    return Key(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(6 * 16, 11 * 16),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }

  // 10. HalfBrick/Line/Face/GreenOrb/SpawnPoint/DoorBlock 及其它特殊case
  if (tileId == 128) {
    return HalfBrick(
      brickpos: Vector2(
        (x + offsetX).floorToDouble(),
        (y + offsetY).floorToDouble(),
      ),
      srcPosition: Vector2(0, 4 * 16),
      type: 0,
      gridSize: tileSize.floorToDouble(),
    );
  }
  if (tileId == 339) {
    return Face(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(19 * 16, 10 * 16),
      type: 0,
      gridSize: tileSize,
    );
  }
  if (tileId == 360) {
    return GreenOrb(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(8 * 16, 11 * 16),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }
  // Line
  const lineTiles = {
    332: [12 * 16, 10 * 16],
    364: [12 * 16, 11 * 16],
    396: [12 * 16, 12 * 16],
    361: [9 * 16, 11 * 16],
    362: [10 * 16, 11 * 16],
    363: [11 * 16, 11 * 16],
  };
  if (lineTiles.containsKey(tileId)) {
    final pos = lineTiles[tileId]!;
    return Line(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(pos[0].toDouble(), pos[1].toDouble()),
      type: 0,
      gridSize: tileSize,
    );
  }
  // SpawnPoint
  if (tileId == 289) {
    final spawnPosition = Vector2((x + offsetX), (y + offsetY));
    if (onSpawnPoint != null) {
      onSpawnPoint(spawnPosition);
    }
    return SpawnPoint(
      brickpos: spawnPosition,
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }
  // DoorBlock
  if (tileId == 425) {
    return DoorBlock(
      brickpos: Vector2((x + offsetX), (y + offsetY)),
      srcPosition: Vector2(9 * 16, 13 * 16),
      type: 0,
      gridSize: tileSize.toDouble(),
    );
  }
  // 默认
  return null;
}
