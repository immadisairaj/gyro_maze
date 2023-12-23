import 'dart:async';
import 'dart:math';

import 'package:arrow_pad/arrow_pad.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gyro_maze/game/gyro_maze_game.dart';
import 'package:gyro_maze/utils/direction.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// main game for the application
class GyroMaze extends StatefulWidget {
  /// create the game
  const GyroMaze({super.key});

  @override
  State<GyroMaze> createState() => _GyroMazeState();
}

class _GyroMazeState extends State<GyroMaze> with WidgetsBindingObserver {
  late final GyroMazeGame _game;

  late bool showController;

  late StreamSubscription<AccelerometerEvent>? subscription;

  late double rotationX = 0;
  late double rotationY = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _game = GyroMazeGame();
    showController = false;

    initGyroAccelOvserver();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // resume the engine when the app is back active
      _game.resumeEngine();
    } else {
      // pause the engine when the app is inactive
      _game.pauseEngine();
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    WakelockPlus.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initGyroAccelOvserver() {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      subscription = accelerometerEventStream().listen(handleGyroAccel);
    }
    rotationX = 0;
    rotationY = 0;
  }

  void handleGyroAccel(AccelerometerEvent event) {
    if (_game.isLoaded && !showController) {
      final dir = Vector2(-event.x, event.y);
      if (dir.length > 1) {
        dir.normalize();

        // the half coverage of the collision towards the side.
        // If collision falls under this, it is considered collided.
        // Else, it is considered not collided.
        DirectionHelper.directionCallbackFromNormal(
          normal: dir,
          downCallback: () => _game.ballDirection = Direction.down,
          upCallback: () => _game.ballDirection = Direction.up,
          leftCallback: () => _game.ballDirection = Direction.left,
          rightCallback: () => _game.ballDirection = Direction.right,
        );
      } else {
        _game.ballDirection = Direction.none;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // enable wake lock as this is a game without touch and relies on
    // screen to be awake
    WakelockPlus.enable();

    final controllerSize = min(
      MediaQuery.of(context).size.height * 0.3,
      MediaQuery.of(context).size.width * 0.5,
    );
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
              alignment: Alignment.topRight,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    tooltip:
                        showController ? 'Hide Controller' : 'Show Controller',
                    icon: Stack(
                      children: [
                        const Positioned.fill(
                          child: Center(
                            child: Icon(
                              Icons.control_camera_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        Center(
                          child: Icon(
                            showController
                                ? Icons.hide_source_outlined
                                : Icons.circle_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        showController = !showController;
                      });
                    },
                  ),
                ),
              ),
            ),
            // TODO(immadisairaj): adjust controller size based on the maze size
            Align(
              alignment: Alignment.bottomRight,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: showController ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: controllerSize,
                    width: controllerSize,
                    child: ArrowPad(
                      innerColor: const Color.fromARGB(255, 54, 52, 52),
                      outerColor: const Color.fromARGB(55, 208, 187, 187),
                      iconColor: const Color.fromARGB(200, 224, 223, 223),
                      clickTrigger: ClickTrigger.onTapUp,
                      onPressedUp: () => _game.ballDirection = Direction.up,
                      onPressedDown: () => _game.ballDirection = Direction.down,
                      onPressedLeft: () => _game.ballDirection = Direction.left,
                      onPressedRight: () =>
                          _game.ballDirection = Direction.right,
                    ),
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
