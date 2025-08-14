import '../objects/Specials/MoveStar.dart';
import 'dart:convert';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'compoents.dart';


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

      final comp = createComponentForTile(
        tileId,
        (x).toDouble(),
        (y).toDouble(),
        (offsetX).toDouble(),
        (offsetY).toDouble(),
        tileSize,
        onSpawnPoint: (pos) => spawnPointPosition = pos,
      );
      if (comp != null) components.add(comp);
      processedTiles.add(i);
    }
  }

  void _parseEntitiesLayer(
    Map<String, dynamic> layer,
    List<PositionComponent> components,
  ) {
    print('开始解析实体层...');
    final entities = layer['entityInstances'] as List<dynamic>? ?? [];
    print('找到 ${entities.length} 个实体');

    for (final entity in entities) {
      final entityId = entity['__identifier'] as String;

      if (entityId == 'Star') {
        print('正在解析 Star 实体...');
        final px = entity['px'] as List<dynamic>? ?? [0, 0];
        double x = (px[0] as num).toDouble();
        double y = (px[1] as num).toDouble();
        double speed = 60;
        Vector2 start = Vector2(x, y);
        Vector2 end = Vector2(x + 64, y);
        print('初始解析位置: start=$start, end=$end');

        final fields = entity['fieldInstances'] as List<dynamic>? ?? [];
        for (final field in fields) {
          final name = field['__identifier'];
          final value = field['__value'];
          if (name == 'Speed' && value != null)
            speed = (value as num).toDouble();
          if (name == 'StartPos' && value != null) {
            start = Vector2(
              16 * (value['cx'] as num).toDouble(),
              16 * (value['cy'] as num).toDouble(),
            );
          }
          if (name == 'Endpos' && value != null) {
            end = Vector2(
              16 * (value['cx'] as num).toDouble(),
              16 * (value['cy'] as num).toDouble(),
            );
          }
        }

        print('最终Star位置: start=$start, end=$end, speed=$speed');
        final star = MovingStar(
          startPosition: start,
          endPosition: end,
          speed: speed,
        );
        components.add(star);
        print('Star 已添加到组件列表');
      }
    }
  }
}
