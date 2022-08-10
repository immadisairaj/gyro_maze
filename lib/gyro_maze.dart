import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/gyro_maze_game.dart';

/// main game for the application
class GyroMaze extends StatefulWidget {
  /// create the game
  const GyroMaze({super.key});

  @override
  State<GyroMaze> createState() => _GyroMazeState();
}

class _GyroMazeState extends State<GyroMaze> {
  late final GyroMazeGame _game;

  @override
  void initState() {
    super.initState();
    _game = GyroMazeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: GameWidget(
          game: _game,
        ),
      ),
    );
  }
}
