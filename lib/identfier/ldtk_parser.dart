import 'dart:convert';

import 'package:_2d_platformergame/objects/half_brick.dart';
import 'package:_2d_platformergame/objects/spike.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import '../objects/brick.dart';
import '../objects/key_block.dart';

class LdtkParser {
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
    final layerWidth = layer['pxWid'] as int? ?? 0;
    final layerHeight = layer['pxHei'] as int? ?? 0;
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

    // 处理钥匙块合并逻辑
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
      if (tileId == 290) {
        // 查找对应的上半部分瓦片
        final matchingTop = tiles.indexWhere(
          (t) => t['id'] == 258 && t['x'] == x && t['y'] == y - tileSize,
        );

        if (matchingTop != -1 && !processedTiles.contains(matchingTop)) {
          // 添加合并后的钥匙块
          components.add(
            KeyBlock(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y - tileSize + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2.zero(),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          processedTiles.add(i);
          processedTiles.add(matchingTop);
          continue;
        }
      }

      // 处理普通瓦片
      switch (tileId) {
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
        case 133:
          // 尖刺

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
          print('Spike实例创建完成');
          break;
        case 258:
          // 未找到匹配的钥匙块下半部分，单独添加
          components.add(
            KeyBlock(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2.zero(),
              type: 0,
              gridSize: tileSize.toDouble(),
            ),
          );
          break;
        default:
          // 未知瓦片ID，输出警告
          print('Unhandled tile ID: $tileId at position ($x, $y)');
      }
      processedTiles.add(i);
    }
  }

  void _parseEntitiesLayer(
    Map<String, dynamic> layer,
    List<PositionComponent> components,
  ) {
    final entities = layer['entities'] as List<dynamic>? ?? [];
    final tileSize = layer['gridSize'] as int? ?? 16;
    final layerHeight = layer['pxHei'] as int? ?? 0;

    for (final entity in entities) {
      final px = entity['px'] as List<dynamic>;
      final x = px[0] as int;
      final y = px[1] as int;
      final entityId = entity['__identifier'] as String;

      // 转换为Flame坐标系（Y轴翻转）
      final flameY = layerHeight - y - tileSize;

      // 根据实体类型创建不同的组件
      if (entityId == 'PlayerSpawn') {
        // 玩家出生点可以在这里处理
        // 目前游戏逻辑中已设置固定出生点，这里可以留空或添加日志
      }
    }
  }
}
