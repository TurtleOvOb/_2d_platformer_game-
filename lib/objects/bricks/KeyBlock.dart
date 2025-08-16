import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';

/// 钥匙块类，根据type参数决定需要哪种钥匙来开启
/// type: 0 - 需要Key1开启
/// type: 1 - 需要Key2开启
class KeyBlock extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type; // 0表示需要Key1开启，1表示需要Key2开启
  final double gridSize;

  KeyBlock({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) {
    position = brickpos;
    size = Vector2(gridSize, gridSize);
  }

  Vector2 get Brickpos => brickpos;

  late RectangleHitbox hitbox;
  late Sprite keySprite;
  bool isCollected = false;

  /// 返回钥匙类型的描述
  String get keyTypeName => type == 0 ? "黄钥匙" : "蓝钥匙";

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(
      'tileset.png', // 图块集路径
      srcPosition: srcPosition, // 从构造函数传入的图块位置
      srcSize: Vector2(gridSize, gridSize), // 方块尺寸
    );

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
        size: Vector2(gridSize, gridSize),
      ),
    );
  }
}
