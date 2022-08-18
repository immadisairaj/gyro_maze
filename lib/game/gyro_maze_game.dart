import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/ball.dart';
import 'package:gyro_maze/game/wall.dart';
import 'package:gyro_maze/utils/direction.dart';
import 'package:gyro_maze/utils/maze_generator.dart';

/// main flame game widget
class GyroMazeGame extends FlameGame
    with
        SingleGameInstance,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  // @override
  // bool get debugMode => true;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 28, 27, 27);

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
    // TODO: make the speed of ball dynamic based on the maze size
    _ball = Ball(
      position: _startPosition +
          Vector2(
            _wallSize * 1.1,
            0,
          ),
      size: _wallSize * 0.7,
    );
    add(_ball);

    // add walls around in and out
    add(
      Wall(
        position: _startPosition + Vector2(0, -_wallSize),
        size: _wallSize,
      ),
    );
    add(
      Wall(
        position: _startPosition + Vector2(_wallSize, -_wallSize),
        size: _wallSize,
        type: EntryExit.entry,
      ),
    );
    add(
      Wall(
        position: _startPosition + Vector2(2 * _wallSize, -_wallSize),
        size: _wallSize,
      ),
    );
    add(
      Wall(
        position: _startPosition +
            Vector2(_numOfBlocks * _wallSize, (_numOfBlocks - 1) * _wallSize),
        size: _wallSize,
      ),
    );
    add(
      Wall(
        position: _startPosition +
            Vector2(_numOfBlocks * _wallSize, (_numOfBlocks - 2) * _wallSize),
        size: _wallSize,
        type: EntryExit.exit,
      ),
    );
    add(
      Wall(
        position: _startPosition +
            Vector2(_numOfBlocks * _wallSize, (_numOfBlocks - 3) * _wallSize),
        size: _wallSize,
      ),
    );

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
