import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

/// wall component for the game
class Wall extends SpriteComponent {
  /// create a single wall component
  ///
  /// size is a required parameter
  /// position is default to (0, 0)
  Wall({Vector2? position, required double size})
      : super(size: Vector2.all(size), position: position ?? Vector2.zero());

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('wall.png');
    await add(RectangleHitbox());
  }
}
