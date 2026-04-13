import 'ball.dart';

class Level {
  final int number;
  final int gridSize;
  final List<Ball> balls;

  const Level({
    required this.number,
    required this.gridSize,
    required this.balls,
  });

  /// Number of unique color pairs on this level.
  int get pairCount => balls.map((b) => b.colorId).toSet().length;
}
