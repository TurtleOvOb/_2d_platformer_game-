import 'dart:convert';
import 'dart:ui';
import 'package:_2d_platformergame/gradient_bricks/half_brick.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import '../gradient_bricks/brick.dart';

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

    for (final tile in gridTiles) {
      final tileId = tile['t'] as int;
      final px = tile['px'] as List<dynamic>;
      final x = px[0] as int;
      final y = px[1] as int;

      // 转换为Flame坐标系（Y轴翻转）

      switch (tileId) {
        case 33:
          // 普通砖块
          components.add(
            Brick(
              brickpos: Vector2(
                (x + offsetX).roundToDouble(),
                (y + offsetY).roundToDouble(),
              ),
              srcPosition: Vector2.zero(),
              type: 0,
              gridSize: tileSize,
            ),
          );
          print('1');
          break;
        case 129:
          // 半砖
          print('2');
          components.add(
            HalfBrick(
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
