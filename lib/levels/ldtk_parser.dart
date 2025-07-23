import 'dart:convert';
import 'dart:io';
import 'package:flame/game.dart';
import '../bricks/brick.dart';

class LdtkParser {
  // 解析LDtk JSON文件并返回砖块列表
  Future<List<Brick>> parseLdtkLevel(String filePath) async {
    final List<Brick> bricks = [];

    // 读取JSON文件
    final file = File(filePath);
    final jsonString = await file.readAsString();
    dynamic jsonData;
    try {
      jsonData = json.decode(jsonString);
    } catch (e) {
      throw FormatException(
        'Failed to parse LDtk JSON file: ${e.toString()}\nFile path: $filePath',
      );
    }

    // 解析第一层关卡数据 (简化版)
    final levels = jsonData['levels'];
    if (levels is List && levels.isNotEmpty) {
      final firstLevel = levels[0];
      final layerInstances = firstLevel['layerInstances'];

      if (layerInstances is List) {
        for (var layer in layerInstances) {
          if (layer['__identifier'] == 'Bricks') {
            // 处理砖块图层
            final gridTiles = layer['gridTiles'];
            if (gridTiles is List) {
              for (var tile in gridTiles) {
                final x = tile['px'][0].toDouble();
                final y = tile['px'][1].toDouble();

                // LDtk使用左下角为原点，Flame使用左上角为原点，需要转换坐标
                final flameY =
                    (firstLevel['pxHei'] as int).toDouble() - y - 50; // 50是砖块高度

                // 创建砖块并添加到列表
                bricks.add(Brick(brickpos: Vector2(x, flameY)));
              }
            }
          }
        }
      }
    }

    return bricks;
  }
}
