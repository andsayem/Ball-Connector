class Ball {
  final int colorId; // index into kBallColors
  final int row;
  final int col;

  const Ball({
    required this.colorId,
    required this.row,
    required this.col,
  });

  @override
  String toString() => 'Ball(colorId:$colorId, row:$row, col:$col)';
}
