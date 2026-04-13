import 'package:flutter/material.dart';

class PathUtils {
  /// Generates a smooth Catmull-Rom spline through the given control points.
  static List<Offset> catmullRomSpline(
    List<Offset> points, {
    int segments = 6,
  }) {
    if (points.length < 2) return List.from(points);
    if (points.length == 2) {
      final result = <Offset>[];
      for (int i = 0; i <= segments; i++) {
        final t = i / segments;
        result.add(Offset(
          points[0].dx + (points[1].dx - points[0].dx) * t,
          points[0].dy + (points[1].dy - points[0].dy) * t,
        ));
      }
      return result;
    }

    // Virtual endpoints so the spline passes through first and last points
    final p = <Offset>[
      points[0] + (points[0] - points[1]),
      ...points,
      points.last + (points.last - points[points.length - 2]),
    ];

    final result = <Offset>[];

    for (int i = 1; i < p.length - 2; i++) {
      final p0 = p[i - 1];
      final p1 = p[i];
      final p2 = p[i + 1];
      final p3 = p[i + 2];

      for (int j = 0; j <= segments; j++) {
        final t = j / segments;
        final t2 = t * t;
        final t3 = t2 * t;

        final x = 0.5 *
            (2 * p1.dx +
                (-p0.dx + p2.dx) * t +
                (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * t2 +
                (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * t3);

        final y = 0.5 *
            (2 * p1.dy +
                (-p0.dy + p2.dy) * t +
                (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * t2 +
                (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * t3);

        result.add(Offset(x, y));
      }
    }

    return result;
  }

  /// Returns true if segments (a1→a2) and (b1→b2) properly intersect
  /// (ignoring near-endpoint overlaps).
  static bool segmentsIntersect(
    Offset a1,
    Offset a2,
    Offset b1,
    Offset b2,
  ) {
    final dx1 = a2.dx - a1.dx;
    final dy1 = a2.dy - a1.dy;
    final dx2 = b2.dx - b1.dx;
    final dy2 = b2.dy - b1.dy;

    final denom = dx1 * dy2 - dy1 * dx2;
    if (denom.abs() < 1e-8) return false; // parallel / collinear

    final diffX = b1.dx - a1.dx;
    final diffY = b1.dy - a1.dy;

    final t = (diffX * dy2 - diffY * dx2) / denom;
    final u = (diffX * dy1 - diffY * dx1) / denom;

    return t > 0.05 && t < 0.95 && u > 0.05 && u < 0.95;
  }

  /// Returns true if [path] crosses any path in [existingPaths].
  static bool pathCrossesExisting(
    List<Offset> path,
    List<List<Offset>> existingPaths,
  ) {
    if (path.length < 2) return false;
    for (final existing in existingPaths) {
      if (existing.length < 2) continue;
      for (int i = 0; i < path.length - 1; i++) {
        for (int j = 0; j < existing.length - 1; j++) {
          if (segmentsIntersect(
            path[i],
            path[i + 1],
            existing[j],
            existing[j + 1],
          )) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
