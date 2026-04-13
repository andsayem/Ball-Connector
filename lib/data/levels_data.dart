import 'dart:math';

import '../models/ball.dart';
import '../models/level.dart';

const int kGeneratedLevelCount = 25;

final List<Level> kLevels = List.unmodifiable([
  ..._baseLevels,
  ...List.generate(
    kGeneratedLevelCount - _baseLevels.length,
    (index) => _buildGeneratedLevel(index + _baseLevels.length + 1),
  ),
]);

final List<Level> _baseLevels = [
  Level(
    number: 1,
    gridSize: 4,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 3, col: 2),
      Ball(colorId: 1, row: 0, col: 3), Ball(colorId: 1, row: 3, col: 3),
      Ball(colorId: 2, row: 1, col: 2), Ball(colorId: 2, row: 3, col: 0),
    ],
  ),
  Level(
    number: 2,
    gridSize: 4,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 3, col: 3),
      Ball(colorId: 1, row: 0, col: 2), Ball(colorId: 1, row: 3, col: 0),
      Ball(colorId: 2, row: 0, col: 3), Ball(colorId: 2, row: 2, col: 1),
      Ball(colorId: 3, row: 1, col: 0), Ball(colorId: 3, row: 3, col: 2),
    ],
  ),
  Level(
    number: 3,
    gridSize: 5,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 4, col: 3),
      Ball(colorId: 1, row: 0, col: 4), Ball(colorId: 1, row: 4, col: 1),
      Ball(colorId: 2, row: 0, col: 2), Ball(colorId: 2, row: 4, col: 4),
      Ball(colorId: 3, row: 2, col: 0), Ball(colorId: 3, row: 2, col: 4),
    ],
  ),
  Level(
    number: 4,
    gridSize: 5,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 4, col: 2),
      Ball(colorId: 1, row: 0, col: 4), Ball(colorId: 1, row: 4, col: 0),
      Ball(colorId: 2, row: 0, col: 2), Ball(colorId: 2, row: 3, col: 4),
      Ball(colorId: 3, row: 2, col: 1), Ball(colorId: 3, row: 4, col: 4),
      Ball(colorId: 4, row: 1, col: 3), Ball(colorId: 4, row: 3, col: 1),
    ],
  ),
  Level(
    number: 5,
    gridSize: 6,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 5, col: 5),
      Ball(colorId: 1, row: 0, col: 5), Ball(colorId: 1, row: 5, col: 0),
      Ball(colorId: 2, row: 0, col: 2), Ball(colorId: 2, row: 5, col: 3),
      Ball(colorId: 3, row: 2, col: 1), Ball(colorId: 3, row: 4, col: 4),
      Ball(colorId: 4, row: 1, col: 4), Ball(colorId: 4, row: 3, col: 2),
    ],
  ),
  Level(
    number: 6,
    gridSize: 6,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 5, col: 4),
      Ball(colorId: 1, row: 0, col: 5), Ball(colorId: 1, row: 5, col: 1),
      Ball(colorId: 2, row: 0, col: 2), Ball(colorId: 2, row: 3, col: 5),
      Ball(colorId: 3, row: 2, col: 0), Ball(colorId: 3, row: 5, col: 3),
      Ball(colorId: 4, row: 1, col: 1), Ball(colorId: 4, row: 4, col: 4),
      Ball(colorId: 5, row: 2, col: 4), Ball(colorId: 5, row: 4, col: 2),
    ],
  ),
  Level(
    number: 7,
    gridSize: 7,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 6, col: 5),
      Ball(colorId: 1, row: 0, col: 6), Ball(colorId: 1, row: 6, col: 1),
      Ball(colorId: 2, row: 0, col: 3), Ball(colorId: 2, row: 6, col: 4),
      Ball(colorId: 3, row: 3, col: 0), Ball(colorId: 3, row: 3, col: 6),
      Ball(colorId: 4, row: 1, col: 2), Ball(colorId: 4, row: 5, col: 4),
      Ball(colorId: 5, row: 2, col: 5), Ball(colorId: 5, row: 4, col: 2),
    ],
  ),
  Level(
    number: 8,
    gridSize: 7,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 6, col: 4),
      Ball(colorId: 1, row: 0, col: 4), Ball(colorId: 1, row: 6, col: 0),
      Ball(colorId: 2, row: 0, col: 6), Ball(colorId: 2, row: 3, col: 0),
      Ball(colorId: 3, row: 6, col: 6), Ball(colorId: 3, row: 3, col: 6),
      Ball(colorId: 4, row: 2, col: 2), Ball(colorId: 4, row: 4, col: 4),
      Ball(colorId: 5, row: 1, col: 5), Ball(colorId: 5, row: 5, col: 1),
      Ball(colorId: 6, row: 3, col: 3), Ball(colorId: 6, row: 1, col: 1),
    ],
  ),
  Level(
    number: 9,
    gridSize: 8,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 7, col: 6),
      Ball(colorId: 1, row: 0, col: 7), Ball(colorId: 1, row: 7, col: 1),
      Ball(colorId: 2, row: 0, col: 3), Ball(colorId: 2, row: 7, col: 5),
      Ball(colorId: 3, row: 3, col: 0), Ball(colorId: 3, row: 5, col: 7),
      Ball(colorId: 4, row: 2, col: 2), Ball(colorId: 4, row: 5, col: 5),
      Ball(colorId: 5, row: 1, col: 6), Ball(colorId: 5, row: 6, col: 2),
      Ball(colorId: 6, row: 4, col: 3), Ball(colorId: 6, row: 3, col: 5),
    ],
  ),
  Level(
    number: 10,
    gridSize: 8,
    balls: [
      Ball(colorId: 0, row: 0, col: 0), Ball(colorId: 0, row: 7, col: 6),
      Ball(colorId: 1, row: 0, col: 7), Ball(colorId: 1, row: 7, col: 0),
      Ball(colorId: 2, row: 0, col: 3), Ball(colorId: 2, row: 7, col: 4),
      Ball(colorId: 3, row: 3, col: 0), Ball(colorId: 3, row: 4, col: 7),
      Ball(colorId: 4, row: 1, col: 1), Ball(colorId: 4, row: 6, col: 6),
      Ball(colorId: 5, row: 1, col: 6), Ball(colorId: 5, row: 6, col: 1),
      Ball(colorId: 6, row: 2, col: 4), Ball(colorId: 6, row: 5, col: 3),
      Ball(colorId: 7, row: 4, col: 2), Ball(colorId: 7, row: 3, col: 5),
    ],
  ),
];

Level _buildGeneratedLevel(int number) {
  final gridSize = min(10, 4 + ((number - 1) ~/ 4));
  final pairCount = min(gridSize, 3 + ((number - 1) ~/ 2));

  return Level(
    number: number,
    gridSize: gridSize,
    balls: _generateVariedPairs(gridSize, pairCount, number),
  );
}

List<Ball> _generateVariedPairs(int gridSize, int pairCount, int seed) {
  final positions = List<Point<int>>.generate(
    gridSize * gridSize,
    (index) => Point(index ~/ gridSize, index % gridSize),
  );

  final rng = Random(seed * 7919);
  positions.shuffle(rng);

  final balls = <Ball>[];
  for (var i = 0; i < pairCount; i++) {
    final first = positions[2 * i];
    final second = positions[2 * i + 1];
    balls.add(Ball(colorId: i, row: first.x, col: first.y));
    balls.add(Ball(colorId: i, row: second.x, col: second.y));
  }
  return balls;
}

