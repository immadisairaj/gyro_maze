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
    final String imageToLoad;
    switch (type) {
      case EntryExit.entry:
      case EntryExit.exit:
        imageToLoad = 'arrow.png';
        break;
      case EntryExit.none:
        imageToLoad = 'wall.png';
        break;
    }
    sprite = await Sprite.load(imageToLoad);
    if (type == EntryExit.exit) {
      position += Vector2(0, size.y);
      await add(RotateEffect.to(-pi / 2, EffectController(duration: 0)));
    }
    await add(RectangleHitbox());
  }
}
