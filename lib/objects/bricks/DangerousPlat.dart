import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:_2d_platformergame/Game/My_Game.dart';
import 'package:_2d_platformergame/player/player.dart';

class DangerousPlat extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  final Vector2 brickpos;
  final Vector2 srcPosition;
  final int type;
  final double gridSize;

  late RectangleHitbox hitbox;
  bool isFalling = false;
  bool isDisappeared = false;
  double fallDelay = 0.5; // 玩家站上去后延迟下落（秒）
  double disappearTime = 1.2; // 下落后消失时间（秒）
  double respawnTime = 2.0; // 消失后多久回到原位（秒）
  Vector2? originalPosition;
  TimerComponent? _fallTimer;
  TimerComponent? _disappearTimer;
  TimerComponent? _respawnTimer;

  DangerousPlat({
    required this.brickpos,
    required this.srcPosition,
    required this.type,
    required this.gridSize,
  }) : super(
         position: Vector2(
           brickpos.x.floorToDouble(),
           brickpos.y.floorToDouble(),
         ),
         size: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
         anchor: Anchor.topLeft,
       );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    originalPosition = position.clone();
    sprite = await Sprite.load(
      'tileset.png',
      srcPosition: Vector2(
        srcPosition.x.floorToDouble(),
        srcPosition.y.floorToDouble(),
      ),
      srcSize: Vector2(gridSize.floorToDouble(), gridSize.floorToDouble()),
    );
    hitbox = RectangleHitbox(collisionType: CollisionType.passive, size: size);
    add(hitbox);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isFalling && !isDisappeared) {
      position.y += 400 * dt; // 下落速度
      // 超出屏幕后直接消失
      if (position.y > game.pxHei + 100) {
        _disappear();
      }
    }
    // 玩家未站立时，碰撞箱与halfplat一致
    final player = game.player;
    if (player == null) return;
    final playerBottom = player.position.y + player.size.y;
    final platTop = position.y;
    hitbox.collisionType =
        (!isFalling && !isDisappeared && playerBottom <= platTop + 10)
            ? CollisionType.passive
            : CollisionType.inactive;
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (isFalling || isDisappeared) return;
    if (other is Player) {
      // 玩家站上去后计时下落
      _fallTimer?.removeFromParent();
      _fallTimer = TimerComponent(
        period: fallDelay,
        repeat: false,
        onTick: _startFalling,
      );
      add(_fallTimer!);
    }
  }

  void _startFalling() {
    isFalling = true;
    _disappearTimer?.removeFromParent();
    _disappearTimer = TimerComponent(
      period: disappearTime,
      repeat: false,
      onTick: _disappear,
    );
    add(_disappearTimer!);
  }

  void _disappear() {
    isFalling = false;
    isDisappeared = true;
    opacity = 0.0;
    hitbox.collisionType = CollisionType.inactive;
    _respawnTimer?.removeFromParent();
    _respawnTimer = TimerComponent(
      period: respawnTime,
      repeat: false,
      onTick: _respawn,
    );
    add(_respawnTimer!);
  }

  void _respawn() {
    isDisappeared = false;
    opacity = 1.0;
    position = originalPosition!.clone();
    hitbox.collisionType = CollisionType.passive;
    _fallTimer = null;
    _disappearTimer = null;
    _respawnTimer = null;
  }
}
