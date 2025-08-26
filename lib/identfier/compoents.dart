import 'package:_2d_platformergame/Objects/Specials/invisibleBlock.dart';
import 'package:_2d_platformergame/Objects/bricks/DangerousPlat.dart';
import 'package:_2d_platformergame/objects/Specials/ConveyorBelt.dart';
import 'package:_2d_platformergame/objects/Specials/DashArrow.dart';
import 'package:_2d_platformergame/objects/Specials/Key.dart';
import 'package:_2d_platformergame/objects/Specials/Star.dart';
import 'package:_2d_platformergame/objects/Specials/face.dart';
import 'package:_2d_platformergame/objects/bricks/ChargedPlatform.dart';
import 'package:_2d_platformergame/objects/bricks/DoorBlock.dart';
import 'package:_2d_platformergame/objects/bricks/KeyBlock.dart';
import 'package:_2d_platformergame/objects/bricks/WhiteBlock.dart';
import 'package:_2d_platformergame/objects/Specials/line.dart';
import 'package:flame/components.dart';
import '../objects/bricks/brick.dart';
import '../objects/bricks/half_brick.dart';
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
    case 7:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 0,
        gridSize: tileSize.toDouble(),
        dashDirection: 2, // 向上冲刺
      );
    case 38:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 0,
        gridSize: tileSize.toDouble(),
        dashDirection: -1, // 向左冲刺
      );
    case 40:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 0,
        gridSize: tileSize.toDouble(),
        dashDirection: 1, // 向右冲刺
      );
    case 71:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 0,
        gridSize: tileSize.toDouble(),
        dashDirection: -2, // 向下冲刺
      );
    case 10:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        type: 1,
        gridSize: tileSize.toDouble(),
        dashDirection: 2, // 向下冲刺
      );
    case 41:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 1,
        gridSize: tileSize.toDouble(),
        dashDirection: -1, // 向下冲刺
      );
    case 43:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 1,
        gridSize: tileSize.toDouble(),
        dashDirection: 1, // 向下冲刺
      );
    case 74:
      return DashArrow(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),

        type: 1,
        gridSize: tileSize.toDouble(),
        dashDirection: -2, // 向下冲刺
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
    // 传送门组1 - 入口（蓝色）
    /* case 45:
      return Portal(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(13 * 16, 1 * 16),
        VisualType: 0, // 入口传送门
        portalGroup: 1, // 组1
        gridSize: tileSize.toDouble(),
      );
    // 传送门组1 - 出口（橙色）
    case 47:
      return Portal(
        brickpos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(15 * 16, 1 * 16),
        VisualType: 1, // 出口传送门
        portalGroup: 1, // 组1
        gridSize: tileSize.toDouble(),
      ); */
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
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 135:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(7 * 16, 4 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 136:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(8 * 16, 4 * 16),
        type: 2,
        gridSize: tileSize.toDouble(),
      );
    case 137:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 4 * 16),
        type: 2,
        gridSize: tileSize.toDouble(),
      );
    case 168:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 5 * 16),
        type: 3,
        gridSize: tileSize.toDouble(),
      );
    case 169:
      return Spike(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(9 * 16, 5 * 16),
        type: 3,
        gridSize: tileSize.toDouble(),
      );
    case 160:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY + 8)),
        srcPosition: Vector2(0, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 161:
      return HalfBrick(
        brickpos: Vector2((x + offsetX), (y + offsetY + 8)),
        srcPosition: Vector2(16, 4 * 16),
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
    // 向右传送带
    case 139:
      return ConveyorBelt(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(11 * 16, 4 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
        beltDirection: 1, // 向右
      );
    // 向左传送带
    case 171:
      return ConveyorBelt(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(11 * 16, 5 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
        beltDirection: -1, // 向左
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
    case 230:
      return WhiteBlock(
        blockPos: Vector2(
          (x + offsetX).floorToDouble(),
          (y + offsetY).floorToDouble(),
        ),
        srcPosition: Vector2(0, 7 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 231:
      return WhiteBlock(
        blockPos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(1 * 16, 7 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 232:
      return WhiteBlock(
        blockPos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(2 * 16, 7 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 236:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(12 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 237:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(13 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 238:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(14 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 242:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(18 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 243:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(19 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 244:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY),
        srcPosition: Vector2(20 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 274:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(18 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 275:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(19 * 16, 7 * 16),
        type: 0,
        gridSize: tileSize.toDouble(),
      );
    case 276:
      return DangerousPlat(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(20 * 16, 7 * 16),
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
    case 269:
      return ChargedPlatform(
        brickpos: Vector2(x + offsetX, y + offsetY + 8),
        srcPosition: Vector2(13 * 16, 7 * 16),
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
    case 321:
      return InvisibleBlock(
        blockPos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(3 * 16, 0),
        type: 0,
        gridSize: tileSize,
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

    case 359:
      return Key(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        srcPosition: Vector2(7 * 16, 11 * 16),
        type: 1,
        gridSize: tileSize.toDouble(),
      );
    case 356:
      return KeyBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        type: 0, // 需要Key1开启的钥匙块
        gridSize: tileSize.toDouble(),
      );
    case 357:
      return KeyBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),

        type: 1, // 需要Key2开启的钥匙块
        gridSize: tileSize.toDouble(),
      );
    case 368:
      return Star(position: Vector2((x + offsetX), (y + offsetY)));
    case 420:
      return KeyBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),
        type: 2, // 需要Key2开启的钥匙块
        gridSize: tileSize.toDouble(),
      );
    case 422:
      return KeyBlock(
        brickpos: Vector2((x + offsetX), (y + offsetY)),

        type: 3, // 需要Key2开启的钥匙块
        gridSize: tileSize.toDouble(),
      );
    case 358:
      return Key(
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
    default:
      return null;
  }
}
