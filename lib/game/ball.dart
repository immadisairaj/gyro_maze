import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gyro_maze/game/wall.dart';
import 'package:gyro_maze/utils/direction.dart';

/// ball component for the game
class Ball extends SpriteComponent with CollisionCallbacks {
  /// create a single ball component
  ///
  /// [size] is a required parameter
  /// [position] is default to (0, 0)
  /// [speed] is default to 30
  /// [direction] is default to [Direction.none]
  Ball({
    Vector2? position,
    required double size,
    this.speed = 30,
    this.direction = Direction.none,
  }) : super(size: Vector2.all(size), position: position ?? Vector2.zero());

  /// set / get the speed of the ball movement
  double speed;

  /// set / get the direction of the ball
  ///
  /// Deafults to [Direction.none]
  Direction direction;

  bool _hasCollidedUp = false;
  bool _hasCollidedDown = false;
  bool _hasCollidedLeft = false;
  bool _hasCollidedRight = false;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('ball.png');
    await add(
      CircleHitbox(),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveBall(dt);
  }

  /// move the ball with delta passed
  void _moveBall(double dt) {
    switch (direction) {
      case Direction.up:
        if (!_hasCollidedUp) {
          position += Vector2(0, -speed * dt);
        }
        break;
      case Direction.down:
        if (!_hasCollidedDown) {
          position += Vector2(0, speed * dt);
        }
        break;
      case Direction.left:
        if (!_hasCollidedLeft) {
          position += Vector2(-speed * dt, 0);
        }
        break;
      case Direction.right:
        if (!_hasCollidedRight) {
          position += Vector2(speed * dt, 0);
        }
        break;
      case Direction.none:
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Wall) {
      final interT = (other.position - position) / 2;
      final penX = other.size.x / 2 + size.x / 2 - interT.x.abs();
      final penY = other.size.y / 2 + size.y / 2 - interT.y.abs();
      if ((penY - penX).abs() > 2) {
        if (penY <= penX) {
          if (interT.y < 0) {
            if (_hasCollidedUp) return;
            _hasCollidedUp = true;
            _hasCollidedDown = false;
          } else {
            if (_hasCollidedDown) return;
            _hasCollidedDown = true;
            _hasCollidedUp = false;
          }
        } else {
          if (interT.x < 0) {
            if (_hasCollidedLeft) return;
            _hasCollidedLeft = true;
            _hasCollidedRight = false;
          } else {
            if (_hasCollidedRight) return;
            _hasCollidedRight = true;
            _hasCollidedLeft = false;
          }
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    _hasCollidedUp = false;
    _hasCollidedDown = false;
    _hasCollidedLeft = false;
    _hasCollidedRight = false;
  }
}
