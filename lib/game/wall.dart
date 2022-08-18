import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

/// determine if the wall is entry or exit wall
enum EntryExit {
  /// entry wall shows down arrow on top
  entry,

  /// exit wall shows right arrow on top
  exit,

  /// normal wall shows no arrow on top
  none,
}

/// wall component for the game
class Wall extends SpriteComponent {
  /// create a single wall component
  ///
  /// - size is a required parameter
  /// - position is default to (0, 0)
  /// - type is to determine what type of wall it is
  Wall({
    Vector2? position,
    required double size,
    this.type = EntryExit.none,
  }) : super(size: Vector2.all(size), position: position ?? Vector2.zero());

  /// type of the wall to determine if it is entry or exit wall or normal
  final EntryExit type;

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('wall.png');
    if (type != EntryExit.none) {
      await add(_Arrow(size: size.x, type: type));
    }
    await add(RectangleHitbox());
  }
}

class _Arrow extends SpriteComponent {
  /// create a single arrow component
  ///
  /// - size is a required parameter
  /// - type is to determine what type of wall it is
  ///
  /// asserts if the type is [EntryExit.none]
  _Arrow({
    required double size,
    required this.type,
  })  : assert(
            type != EntryExit.none, 'type cannot be EntryExit.none for arrows'),
        super(
          size: Vector2.all(size),
        );

  /// type of the wall to determine if it is entry or exit wall or normal
  final EntryExit type;

  @override
  Future<void>? onLoad() async {
    if (type != EntryExit.none) {
      sprite = await Sprite.load('arrow.png');
      // rotate towards right if exit wall
      if (type == EntryExit.exit) {
        position += Vector2(0, size.y);
        await add(RotateEffect.to(-pi / 2, EffectController(duration: 0)));
      }
    }
  }
}
