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
