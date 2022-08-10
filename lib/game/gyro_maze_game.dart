import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/wall.dart';

/// main flame game widget
class GyroMazeGame extends FlameGame with SingleGameInstance {
  @override
  bool get debugMode => true;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 37, 36, 36);

  /// number of blocks for the maze
  double get _numOfBlocks => 21;

  /// wall sie is determined from the screen size
  double get _wallSize =>
      (min(size.x, size.y) - 7 * _numOfBlocks) / _numOfBlocks;

  /// stating position of the maze after reducing the maze size
  Vector2 get _startPosition => Vector2(
        size.x / 2 - _wallSize * _numOfBlocks / 2,
        size.y / 2 - _wallSize * _numOfBlocks / 2,
      );

  @override
  Future<void>? onLoad() {
    add(Wall(size: _wallSize, position: _startPosition));
    add(
      Wall(
        size: _wallSize,
        position: _startPosition + Vector2(_wallSize, 0),
      ),
    );
    add(
      Wall(
        size: _wallSize,
        position: _startPosition + Vector2(0, _wallSize),
      ),
    );
    return null;
  }
}
