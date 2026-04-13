import 'package:flutter/material.dart';

import '../data/levels_data.dart';
import '../models/ball.dart';
import '../models/connection.dart';
import '../models/level.dart';
import '../utils/path_utils.dart';

class GameState extends ChangeNotifier {
  // ── Level ─────────────────────────────────────────────────────────────────
  int _currentLevelIndex = 0;
  late Level _level;

  // ── Connections ───────────────────────────────────────────────────────────
  List<Connection> _connections = [];

  // ── Drawing state ─────────────────────────────────────────────────────────
  Ball? _startBall;
  Ball? _nearEndBall;
  List<Offset> _currentPoints = [];

  /// Snapshot taken at the beginning of a draw gesture; restored on failure.
  List<Connection>? _drawingStartSnapshot;

  // ── Game flags ────────────────────────────────────────────────────────────
  bool _isComplete = false;
  bool _hasError = false;

  // ── Undo ─────────────────────────────────────────────────────────────────
  final List<List<Connection>> _undoStack = [];

  // ── Board metrics (set by GameBoard widget) ───────────────────────────────
  double _boardSize = 300;
  double _boardPadding = 14;

  // ─────────────────────────────────────────────────────────────────────────

  GameState() {
    _level = kLevels[0];
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  Level get level => _level;
  List<Connection> get connections => List.unmodifiable(_connections);
  Ball? get startBall => _startBall;
  Ball? get nearEndBall => _nearEndBall;
  List<Offset> get currentPoints => List.unmodifiable(_currentPoints);
  bool get isDrawing => _startBall != null;
  bool get isComplete => _isComplete;
  bool get hasError => _hasError;
  int get currentLevelIndex => _currentLevelIndex;
  int get totalLevels => kLevels.length;
  bool get canUndo => _undoStack.isNotEmpty;
  int get connectedPairs => _connections.length;

  double get cellSize =>
      (_boardSize - _boardPadding * 2) / _level.gridSize;

  // ── Board metrics ─────────────────────────────────────────────────────────

  void updateBoardMetrics(double boardSize, double padding) {
    _boardSize = boardSize;
    _boardPadding = padding;
  }

  Offset ballPixelCenter(Ball ball) => Offset(
        _boardPadding + ball.col * cellSize + cellSize / 2,
        _boardPadding + ball.row * cellSize + cellSize / 2,
      );

  Ball? _ballAtPosition(Offset pos) {
    Ball? closest;
    double minDist = double.infinity;
    final threshold = cellSize * 0.55;
    for (final ball in _level.balls) {
      final d = (ballPixelCenter(ball) - pos).distance;
      if (d < threshold && d < minDist) {
        minDist = d;
        closest = ball;
      }
    }
    return closest;
  }

  // ── Drawing ───────────────────────────────────────────────────────────────

  void startDrawing(Offset position) {
    final ball = _ballAtPosition(position);
    if (ball == null) return;

    // Save full state so we can restore it if the gesture fails.
    _drawingStartSnapshot = List.from(_connections);

    // Remove any existing connection for this color so the user redraws it.
    _connections.removeWhere((c) => c.colorId == ball.colorId);

    _startBall = ball;
    _currentPoints = [ballPixelCenter(ball)];
    _nearEndBall = null;
    _hasError = false;

    notifyListeners();
  }

  void updateDrawing(Offset position) {
    if (_startBall == null) return;

    // Throttle – only add a point when far enough from the last one.
    if (_currentPoints.isNotEmpty &&
        (_currentPoints.last - position).distance < 6) return;

    _currentPoints.add(position);

    // Highlight same-color target ball when hovering over it.
    final nearby = _ballAtPosition(position);
    _nearEndBall =
        (nearby != null && nearby.colorId == _startBall!.colorId && nearby != _startBall)
            ? nearby
            : null;

    notifyListeners();
  }

  void endDrawing(Offset position) {
    if (_startBall == null) return;

    final endBall = _ballAtPosition(position);
    bool succeeded = false;

    if (endBall != null &&
        endBall.colorId == _startBall!.colorId &&
        endBall != _startBall &&
        _currentPoints.length >= 2) {
      // Snap final point to the target ball center.
      _currentPoints.add(ballPixelCenter(endBall));

      // Remove any existing connection for the target ball as well.
      _connections.removeWhere((c) => c.colorId == endBall.colorId);

      // Build smooth spline.
      final splinePoints =
          PathUtils.catmullRomSpline(_currentPoints, segments: 6);

      // Check against all OTHER colors' paths.
      final existingPaths =
          _connections.map((c) => c.curvePoints).toList();

      if (!PathUtils.pathCrossesExisting(splinePoints, existingPaths)) {
        // ✅ Success — commit to undo stack then add connection.
        if (_drawingStartSnapshot != null) {
          _undoStack.add(_drawingStartSnapshot!);
          if (_undoStack.length > 40) _undoStack.removeAt(0);
        }
        _connections.add(Connection(
          colorId: _startBall!.colorId,
          rawPoints: List.from(_currentPoints),
          curvePoints: splinePoints,
        ));
        succeeded = true;
        _checkCompletion();
      } else {
        _hasError = true; // crossing detected
      }
    } else if (endBall != null &&
        endBall.colorId != _startBall!.colorId) {
      _hasError = true; // wrong color
    }

    // Restore snapshot if we failed (so the old connection comes back).
    if (!succeeded && _drawingStartSnapshot != null) {
      _connections = List.from(_drawingStartSnapshot!);
    }

    _drawingStartSnapshot = null;
    _startBall = null;
    _currentPoints = [];
    _nearEndBall = null;

    notifyListeners();

    if (_hasError) {
      Future.delayed(const Duration(milliseconds: 550), () {
        _hasError = false;
        notifyListeners();
      });
    }
  }

  void cancelDrawing() {
    if (_startBall == null) return;
    if (_drawingStartSnapshot != null) {
      _connections = List.from(_drawingStartSnapshot!);
    }
    _drawingStartSnapshot = null;
    _startBall = null;
    _currentPoints = [];
    _nearEndBall = null;
    notifyListeners();
  }

  // ── Game actions ──────────────────────────────────────────────────────────

  void undo() {
    if (_undoStack.isEmpty) return;
    _connections = _undoStack.removeLast();
    _isComplete = false;
    notifyListeners();
  }

  void restart() {
    if (_connections.isNotEmpty) {
      _undoStack.add(List.from(_connections));
      if (_undoStack.length > 40) _undoStack.removeAt(0);
    }
    _connections = [];
    _currentPoints = [];
    _startBall = null;
    _drawingStartSnapshot = null;
    _nearEndBall = null;
    _isComplete = false;
    _hasError = false;
    notifyListeners();
  }

  void loadLevel(int index) {
    if (index < 0 || index >= kLevels.length) return;
    _currentLevelIndex = index;
    _level = kLevels[index];
    _connections = [];
    _currentPoints = [];
    _startBall = null;
    _drawingStartSnapshot = null;
    _nearEndBall = null;
    _isComplete = false;
    _hasError = false;
    _undoStack.clear();
    notifyListeners();
  }

  void nextLevel() => loadLevel(_currentLevelIndex + 1);

  // ── Private ───────────────────────────────────────────────────────────────

  void _checkCompletion() {
    final connectedIds = _connections.map((c) => c.colorId).toSet();
    final allIds = _level.balls.map((b) => b.colorId).toSet();
    _isComplete = connectedIds.length == allIds.length &&
        connectedIds.containsAll(allIds);
  }
}
