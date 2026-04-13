import 'dart:ui' show Offset;

class Connection {
  final int colorId;
  final List<Offset> rawPoints;   // original touch points
  final List<Offset> curvePoints; // Catmull-Rom smoothed points

  Connection({
    required this.colorId,
    required this.rawPoints,
    required this.curvePoints,
  });
}
