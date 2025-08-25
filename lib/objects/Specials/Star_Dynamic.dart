import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';

class StarDynamic extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final List<Vector2> pathPoints;
  final double speed;
  int _currentTarget = 1;
  bool _forward = true;

  StarDynamic({required this.pathPoints, required this.speed})
    : super(
        position:
            pathPoints.isNotEmpty ? pathPoints[0].clone() : Vector2.zero(),
        size: Vector2.all(16),
        anchor: Anchor.topLeft,
        priority: 10,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(14 * 16, 12 * 16),
      srcSize: Vector2.all(16),
    );
    final double hitboxScale = 0.6;
    final Vector2 hitboxSize = size * hitboxScale;
    final Vector2 hitboxPos = (size - hitboxSize) / 2;
    add(
      RectangleHitbox(
        size: hitboxSize,
        position: hitboxPos,
        anchor: Anchor.topLeft,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (pathPoints.length < 2) return;
    final target = pathPoints[_currentTarget];
    final dir = (target - position);
    final dist = dir.length;
    if (dist < speed * dt) {
      position.setFrom(target);
      if (_forward) {
        if (_currentTarget == pathPoints.length - 1) {
          _forward = false;
          _currentTarget--;
        } else {
          _currentTarget++;
        }
      } else {
        if (_currentTarget == 0) {
          _forward = true;
          _currentTarget++;
        } else {
          _currentTarget--;
        }
      }
    } else {
      position.add(dir.normalized() * speed * dt);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Player) {
      game.playerDeath();
    }
  }
}
