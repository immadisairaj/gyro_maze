import 'package:arrow_pad/arrow_pad.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/gyro_maze_game.dart';
import 'package:gyro_maze/utils/direction.dart';

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
        child: Stack(
          children: [
            Positioned.fill(
              child: GameWidget(
                game: _game,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.2,
                child: GestureDetector(
                  child: ArrowPad(
                    innerColor: const Color.fromARGB(255, 54, 52, 52),
                    outerColor: const Color.fromARGB(55, 208, 187, 187),
                    iconColor: const Color.fromARGB(200, 224, 223, 223),
                    onPressedUp: () => _game.ballDirection = Direction.up,
                    onPressedDown: () => _game.ballDirection = Direction.down,
                    onPressedLeft: () => _game.ballDirection = Direction.left,
                    onPressedRight: () => _game.ballDirection = Direction.right,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
