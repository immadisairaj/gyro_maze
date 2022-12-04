import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:gyro_maze/game/wall.dart';
import 'package:gyro_maze/utils/direction.dart';

/// ball component for the game
class Ball extends SpriteComponent with CollisionCallbacks, KeyboardHandler {
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
    // debugMode = true;
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
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    // TODO: fix when game controller is used and immediately key is used
    Direction? keyDirection;
    if (isKeyDown) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
          event.logicalKey == LogicalKeyboardKey.keyW) {
        keyDirection = Direction.up;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.keyS) {
        keyDirection = Direction.down;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.keyA) {
        keyDirection = Direction.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.keyD) {
        keyDirection = Direction.right;
      }
    }

    if (isKeyDown && keyDirection != null) {
      direction = keyDirection;
      // returns false as the key handler is being handled
      return false;
    }

    // returns true as the key handler is not being handled
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Wall) {
      if (intersectionPoints.length == 2) {
        final ballCenter = position + Vector2(size.x / 2, size.y / 2);
        // generate a vector from the center of the ball to
        // the avg of the intersection points.
        final collisionNormal =
            ((intersectionPoints.first + intersectionPoints.last) / 2) -
                ballCenter;
        final distance = collisionNormal.length;
        // the half coverage of the collision towards the side.
        // If collision falls under this, it is considered collided.
        // Else, it is considered not collided.
        const angleThresholdInDegrees = 46;
        final collisionAngleInDegrees =
            collisionNormal.screenAngle() / pi * 180;

        if (distance <= size.x / 2) {
          if (collisionNormal.x > 0 &&
              collisionAngleInDegrees > (90 - angleThresholdInDegrees) &&
              collisionAngleInDegrees < (90 + angleThresholdInDegrees)) {
            _hasCollidedRight = true;
            _hasCollidedLeft = false;
          } else if (collisionNormal.x < 0 &&
              collisionAngleInDegrees > (-90 - angleThresholdInDegrees) &&
              collisionAngleInDegrees < (-90 + angleThresholdInDegrees)) {
            _hasCollidedLeft = true;
            _hasCollidedRight = false;
          }
          if (collisionNormal.y > 0 &&
                  (collisionAngleInDegrees < (-180 + angleThresholdInDegrees) &&
                      collisionAngleInDegrees >= -180) ||
              collisionAngleInDegrees > (180 - angleThresholdInDegrees) &&
                  collisionAngleInDegrees <= 180) {
            _hasCollidedDown = true;
            _hasCollidedUp = false;
          } else if (collisionNormal.y < 0 &&
              collisionAngleInDegrees > (0 - angleThresholdInDegrees) &&
              collisionAngleInDegrees < (0 + angleThresholdInDegrees)) {
            _hasCollidedUp = true;
            _hasCollidedDown = false;
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
