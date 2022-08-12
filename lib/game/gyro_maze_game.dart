import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/ball.dart';
import 'package:gyro_maze/game/wall.dart';
import 'package:gyro_maze/utils/direction.dart';
import 'package:gyro_maze/utils/maze_generator.dart';

/// main flame game widget
class GyroMazeGame extends FlameGame
    with SingleGameInstance, HasCollisionDetection {
  // @override
  // bool get debugMode => true;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 37, 36, 36);

  /// number of blocks for the maze
  /// should always try to keep it odd number
  int get _numOfBlocks => 21;

  /// wall sie is determined from the screen size
  double get _wallSize => (min(size.x, size.y) * 0.8) / _numOfBlocks;

  /// stating position of the maze after reducing the maze size
  Vector2 get _startPosition => Vector2(
        size.x / 2 - _wallSize * _numOfBlocks / 2,
        size.y / 2 - _wallSize * _numOfBlocks / 2,
      );

  late Ball _ball;

  /// set or get ball direction
  Direction get ballDirection => _ball.direction;
  set ballDirection(Direction newDirection) => _ball.direction = newDirection;

  @override
  Future<void>? onLoad() {
    // add ball
    _ball = Ball(
      position: _startPosition +
          Vector2(
            _wallSize * 1.1,
            -_wallSize,
          ),
      size: _wallSize * 0.7,
    );
    add(_ball);
    // genearte and add maze walls
    _addMaze();

    return null;
  }

  void _addMaze() {
    // we get the maze as complete closed
    final maze = MazeGenerator.generate(_numOfBlocks, _numOfBlocks);
    // open the maze for in and out
    maze[0][1] = false;
    maze[_numOfBlocks - 2][_numOfBlocks - 1] = false;

    // arrange maze
    for (var row = 0; row < maze.length; row++) {
      for (var col = 0; col < maze[row].length; col++) {
        if (maze[row][col]) {
          add(
            Wall(
              position: _startPosition +
                  Vector2(
                    col * _wallSize,
                    row * _wallSize,
                  ),
              size: _wallSize,
            ),
          );
        }
      }
    }
  }
}
