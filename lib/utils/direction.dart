import 'dart:math';

import 'package:flame/extensions.dart';

/// The direction enum
enum Direction {
  /// direction towards up
  up(1),

  /// direction towards down
  down(2),

  /// direction towards left
  left(3),

  /// direction towards right
  right(4),

  /// direction is not specified
  none(0);

  /// set the value for direction
  const Direction(this.value);

  /// value for a particular direction
  final int value;
}

/// Direction Helper class is mainly used as to calculate the direction
/// and help with the direction related operations
///
/// Use [directionCallbackFromNormal] by sending the normal vector along
/// with the direction call backs to trigger based on the direction
class DirectionHelper {
  /// calls back the specified callbacks by taking [normal] vector.
  /// It uses the [angleThreshold] to determine threshold for the direction.
  ///
  /// [angleThreshold] is in degrees and the default value is 45.0.
  static void directionCallbackFromNormal({
    required Vector2 normal,
    double angleThreshold = 45.0,
    void Function()? rightCallback,
    void Function()? leftCallback,
    void Function()? upCallback,
    void Function()? downCallback,
  }) {
    final angleInDegrees = normal.screenAngle() / pi * 180;

    if (normal.x > 0 &&
        angleInDegrees > (90 - angleThreshold) &&
        angleInDegrees < (90 + angleThreshold)) {
      if (rightCallback != null) rightCallback();
    } else if (normal.x < 0 &&
        angleInDegrees > (-90 - angleThreshold) &&
        angleInDegrees < (-90 + angleThreshold)) {
      if (leftCallback != null) leftCallback();
    }
    if (normal.y > 0 &&
            (angleInDegrees < (-180 + angleThreshold) &&
                angleInDegrees >= -180) ||
        angleInDegrees > (180 - angleThreshold) && angleInDegrees <= 180) {
      if (downCallback != null) downCallback();
    } else if (normal.y < 0 &&
        angleInDegrees > (0 - angleThreshold) &&
        angleInDegrees < (0 + angleThreshold)) {
      if (upCallback != null) upCallback();
    }
  }
}
