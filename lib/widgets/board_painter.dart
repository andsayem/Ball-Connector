import 'package:flutter/material.dart';

import '../models/ball.dart';
import '../models/connection.dart';
import '../models/level.dart';
import '../utils/color_palette.dart';

class BoardPainter extends CustomPainter {
  final Level level;
  final List<Connection> connections;
  final List<Offset>? currentPath;
  final int? drawingColorId;
  final double cellSize;
  final double boardPadding;
  final Ball? nearEndBall;
  final Ball? startBall;

  BoardPainter({
    required this.level,
    required this.connections,
    this.currentPath,
    this.drawingColorId,
    required this.cellSize,
    required this.boardPadding,
    this.nearEndBall,
    this.startBall,
  });

  Offset _ballCenter(int row, int col) => Offset(
        boardPadding + col * cellSize + cellSize / 2,
        boardPadding + row * cellSize + cellSize / 2,
      );

  @override
  void paint(Canvas canvas, Size size) {
    _drawBoard(canvas, size);
    _drawGrid(canvas);
    _drawConnections(canvas);
    _drawCurrentPath(canvas);
    _drawBalls(canvas);
  }

  // ── Board ────────────────────────────────────────────────────────────────

  void _drawBoard(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect =
        RRect.fromRectAndRadius(rect, const Radius.circular(22));

    // Outer neon glow
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0x40667EEA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 22),
    );

    // Board body (dark gradient — lighter top-left gives 3-D depth illusion)
    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E3C), Color(0xFF0C0C1E)],
        ).createShader(rect),
    );

    // Inner subtle bevel highlight (top-left edge lighter)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.75, 0.75, size.width - 1.5, size.height - 1.5),
        const Radius.circular(21.5),
      ),
      Paint()
        ..color = Colors.white.withOpacity(0.07)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Inner shadow on all sides (inset feel)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(3, 3, size.width - 6, size.height - 6),
        const Radius.circular(19),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 6),
    );
  }

  // ── Grid ─────────────────────────────────────────────────────────────────

  void _drawGrid(Canvas canvas) {
    final gridLen = level.gridSize * cellSize;
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 0.5;
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.14);

    for (int i = 0; i <= level.gridSize; i++) {
      final x = boardPadding + i * cellSize;
      final y = boardPadding + i * cellSize;
      canvas.drawLine(Offset(x, boardPadding), Offset(x, boardPadding + gridLen), linePaint);
      canvas.drawLine(Offset(boardPadding, y), Offset(boardPadding + gridLen, y), linePaint);
    }

    // Intersection dots
    for (int r = 0; r <= level.gridSize; r++) {
      for (int c = 0; c <= level.gridSize; c++) {
        canvas.drawCircle(
          Offset(boardPadding + c * cellSize, boardPadding + r * cellSize),
          1.2,
          dotPaint,
        );
      }
    }
  }

  // ── Connections ───────────────────────────────────────────────────────────

  void _drawConnections(Canvas canvas) {
    for (final conn in connections) {
      if (conn.curvePoints.length < 2) continue;
      _drawStyledPath(canvas, conn.curvePoints, kBallColors[conn.colorId], 1.0);
    }
  }

  void _drawCurrentPath(Canvas canvas) {
    if (currentPath == null ||
        currentPath!.length < 2 ||
        drawingColorId == null) return;
    _drawStyledPath(
        canvas, currentPath!, kBallColors[drawingColorId!], 0.72);
  }

  void _drawStyledPath(
    Canvas canvas,
    List<Offset> pts,
    BallColor bc,
    double opacity,
  ) {
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }

    // Wide outer glow
    canvas.drawPath(
      path,
      Paint()
        ..color = bc.glow.withOpacity(0.35 * opacity)
        ..strokeWidth = cellSize * 0.28
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, cellSize * 0.08),
    );

    // Main colored stroke
    canvas.drawPath(
      path,
      Paint()
        ..color = bc.main.withOpacity(opacity)
        ..strokeWidth = cellSize * 0.14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    // Centre highlight stripe (gives the tube/3-D look)
    canvas.drawPath(
      path,
      Paint()
        ..color = bc.highlight.withOpacity(0.35 * opacity)
        ..strokeWidth = cellSize * 0.04
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
  }

  // ── Balls ─────────────────────────────────────────────────────────────────

  void _drawBalls(Canvas canvas) {
    for (final ball in level.balls) {
      final center = _ballCenter(ball.row, ball.col);
      final bc = kBallColors[ball.colorId];
      final isConnected = connections.any((c) => c.colorId == ball.colorId);
      final isStart = startBall == ball;
      final isTarget = nearEndBall == ball;
      final r = cellSize * 0.30;

      // ── Glow aura ──────────────────────────────────────────────────────
      final glowAlpha = isStart || isTarget ? 0.85 : (isConnected ? 0.55 : 0.30);
      canvas.drawCircle(
        center,
        r * 1.6,
        Paint()
          ..color = bc.glow.withOpacity(glowAlpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.9),
      );

      // ── Drop shadow ────────────────────────────────────────────────────
      canvas.drawCircle(
        center + Offset(0, r * 0.3),
        r * 0.85,
        Paint()
          ..color = Colors.black.withOpacity(0.55)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.5),
      );

      // ── 3-D sphere body (radial gradient) ──────────────────────────────
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.38, -0.46),
            radius: 1.0,
            colors: [bc.highlight, bc.main, bc.shadow],
            stops: const [0.0, 0.52, 1.0],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );

      // ── Specular highlight ─────────────────────────────────────────────
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.42, -0.52),
            radius: 0.52,
            colors: [
              Colors.white.withOpacity(0.80),
              Colors.white.withOpacity(0.0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );

      // ── Outer ring ─────────────────────────────────────────────────────
      canvas.drawCircle(
        center,
        r + 1.8,
        Paint()
          ..color = bc.main.withOpacity(isConnected || isStart ? 0.90 : 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );

      // ── Active pulse ring (start or hover target) ──────────────────────
      if (isStart || isTarget) {
        canvas.drawCircle(
          center,
          r + 5.5,
          Paint()
            ..color = bc.main.withOpacity(0.38)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
        canvas.drawCircle(
          center,
          r + 9,
          Paint()
            ..color = bc.main.withOpacity(0.14)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter old) => true;
}
