import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import 'board_painter.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Offset? _lastPos;
  static const double _padding = 14.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = min(constraints.maxWidth, constraints.maxHeight).toDouble();

      // Keep board metrics in sync whenever layout changes.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<GameState>().updateBoardMetrics(size, _padding);
        }
      });

      return SizedBox(
        width: size,
        height: size,
        child: GestureDetector(
          onPanStart: (d) {
            _lastPos = d.localPosition;
            context.read<GameState>().startDrawing(d.localPosition);
          },
          onPanUpdate: (d) {
            _lastPos = d.localPosition;
            context.read<GameState>().updateDrawing(d.localPosition);
          },
          onPanEnd: (_) {
            if (_lastPos != null) {
              context.read<GameState>().endDrawing(_lastPos!);
            }
            _lastPos = null;
          },
          onPanCancel: () {
            context.read<GameState>().cancelDrawing();
            _lastPos = null;
          },
          child: Consumer<GameState>(
            builder: (context, state, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: BoardPainter(
                  level: state.level,
                  connections: state.connections.toList(),
                  currentPath: state.isDrawing && state.currentPoints.length >= 2
                      ? state.currentPoints.toList()
                      : null,
                  drawingColorId: state.startBall?.colorId,
                  cellSize: state.cellSize,
                  boardPadding: _padding,
                  nearEndBall: state.nearEndBall,
                  startBall: state.startBall,
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
