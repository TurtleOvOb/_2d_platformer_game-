import 'dart:convert';

import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/objects/SpawnPoint.dart';
import 'package:_2d_platformergame/objects/bricks/half_brick.dart';
import 'package:_2d_platformergame/objects/key1.dart';
import 'package:_2d_platformergame/objects/spike.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import '../objects/bricks/brick.dart';
import '../objects/bricks/key_block1.dart';

class LdtkParser extends Component with HasGameReference<MyGame> {
  Vector2? spawnPointPosition;
  Future<List<PositionComponent>> parseLdtkLevel(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final jsonData = json.decode(jsonString);

    // 获取第一个关卡数据
    final components = <PositionComponent>[];

    // 处理图层数据
    final layerInstances = jsonData['layerInstances'] as List<dynamic>;
    if (layerInstances.isEmpty) {
      throw Exception('No layer instances found in LDtk file');
    }
    for (final layer in layerInstances) {
      final layerType = layer['__type'] as String;
      if (layerType == 'Tiles') {
        await _parseTilesLayer(layer, components);
      } else if (layerType == 'Entities') {
        _parseEntitiesLayer(layer, components);
      }
    }

    return components;
  }

  Future<void> _parseTilesLayer(
    Map<String, dynamic> layer,
    List<PositionComponent> components,
  ) async {
    final gridTiles = layer['gridTiles'] as List<dynamic>? ?? [];
    final tileSize = layer['gridSize'] as int? ?? 16;
    final offsetX = layer['pxOffsetX'] as int? ?? 0;
    final offsetY = layer['pxOffsetY'] as int? ?? 0;

    // 收集所有瓦片数据
    final tiles = <Map<String, dynamic>>[];
    for (final tile in gridTiles) {
      final tileId = tile['t'] as int;
      final px = tile['px'] as List<dynamic>;
      final x = px[0] as int;
      final y = px[1] as int;
      tiles.add({
        'id': tileId,
        'x': x,
        'y': y,
        'offsetX': offsetX,
        'offsetY': offsetY,
      });
    }

    final processedTiles = <int>{};
    for (int i = 0; i < tiles.length; i++) {
      if (processedTiles.contains(i)) continue;

      final tile = tiles[i];
      final tileId = tile['id'] as int;
      final x = tile['x'] as int;
      final y = tile['y'] as int;
      final offsetX = tile['offsetX'] as int;
      final offsetY = tile['offsetY'] as int;

      // 假设钥匙块上半部分ID为130，下半部分ID为131

      // 处理普通瓦片
      switch (tileId) {
        case 0:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(0, 0),
              type: 0,
              gridSize: tileSize,
            ),
          );
          break;
        case 2:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 0),
              type: 0,
              gridSize: tileSize,
            ),
          );
          break;
        case 32:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(0, 16),
              type: 0,
              gridSize: tileSize,
            ),
          );
          break;
        case 33:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(16, 16),
              type: 0,
              gridSize: tileSize,
            ),
          );
          break;
        case 34:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 16),
              type: 0,
              gridSize: tileSize,
            ),
          );
          break;
        case 64:
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(0 * 16, 2 * 16),
              type: 0,
              gridSize: tileSize,
            ),
          );
        case 66:
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 2 * 16),
              type: 0,
              gridSize: tileSize,
            ),
          );
        case 128:
          components.add(
            HalfBrick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(0, 4 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
        case 129:
          // 半砖
          components.add(
            HalfBrick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(1 * 16, 4 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        case 130:
          components.add(
            HalfBrick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 4 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );

        case 133:
          components.add(
            Spike(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(5 * 16, 4 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        case 160:
          components.add(
            HalfBrick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(0 * 16, 5 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        case 162:
          components.add(
            HalfBrick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 5 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
        case 258:
          components.add(
            KeyBlock(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 8 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        case 290:
          components.add(
            KeyBlock(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(2 * 16, 9 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        case 358:
          // 钥匙1
          components.add(
            Key1(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2(4 * 16, 8 * 16),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
        // 在LdtkParser类中添加一个属性来存储SpawnPoint位置

        // 在_parseTilesLayer方法中
        case 289:
          final spawnPosition = Vector2(
            (x + offsetX).roundToDouble(),
            (y + offsetY).roundToDouble(),
          );
          components.add(
            SpawnPoint(
              brickpos: spawnPosition,
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          spawnPointPosition = spawnPosition;

          break;
        //  default:
      }
      processedTiles.add(i);
    }
  }

  void _parseEntitiesLayer(
    Map<String, dynamic> layer,
    List<PositionComponent> components,
  ) {
    final entities = layer['entities'] as List<dynamic>? ?? [];

    for (final entity in entities) {
      final entityId = entity['__identifier'] as String;

      // 转换为Flame坐标系（Y轴翻转）

      // 根据实体类型创建不同的组件
      if (entityId == 'PlayerSpawn') {
        // 玩家出生点可以在这里处理
        // 目前游戏逻辑中已设置固定出生点，这里可以留空或添加日志
      }
    }
  }
}
