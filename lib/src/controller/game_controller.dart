import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/hole.dart';

class GameController extends ChangeNotifier {
  GameController();

  static const int laneCount = 3;
  static const double collisionLine = 0.84;
  static const double holeHeight = 0.14;
  static const Duration tickRate = Duration(milliseconds: 16);
  static const Duration spawnInterval = Duration(seconds: 3);
  static const double scrollSpeedPerSecond = 0.35;

  final Random _random = Random();
  final List<Hole> _holes = [];

  int _currentLane = 1;
  bool _isGameOver = false;
  Timer? _gameLoopTimer;
  DateTime? _lastTick;
  Duration _timeSinceSpawn = Duration.zero;

  int get currentLane => _currentLane;
  bool get isGameOver => _isGameOver;
  List<Hole> get holes => List.unmodifiable(_holes);

  void start() {
    _resetState();
    _gameLoopTimer = Timer.periodic(tickRate, (_) => _tick());
  }

  void disposeController() {
    _gameLoopTimer?.cancel();
    _gameLoopTimer = null;
  }

  void restart() {
    start();
    notifyListeners();
  }

  void swipeLeft() {
    if (_isGameOver || _currentLane == 0) return;
    _currentLane -= 1;
    notifyListeners();
  }

  void swipeRight() {
    if (_isGameOver || _currentLane == laneCount - 1) return;
    _currentLane += 1;
    notifyListeners();
  }

  void _resetState() {
    _gameLoopTimer?.cancel();
    _holes.clear();
    _currentLane = 1;
    _isGameOver = false;
    _lastTick = DateTime.now();
    _timeSinceSpawn = Duration.zero;
    notifyListeners();
  }

  void _tick() {
    if (_isGameOver) return;

    final DateTime now = DateTime.now();
    final DateTime previous = _lastTick ?? now;
    final Duration dt = now.difference(previous);
    _lastTick = now;

    _timeSinceSpawn += dt;
    if (_timeSinceSpawn >= spawnInterval) {
      _timeSinceSpawn -= spawnInterval;
      _holes.add(Hole(lane: _random.nextInt(laneCount), progress: -holeHeight));
    }

    final double deltaProgress = dt.inMilliseconds / 1000 * scrollSpeedPerSecond;
    for (final Hole hole in _holes) {
      hole.progress += deltaProgress;
    }

    _holes.removeWhere((Hole hole) => hole.progress > 1.2);

    _checkCollision();
    notifyListeners();
  }

  void _checkCollision() {
    for (final Hole hole in _holes) {
      final bool laneMatch = hole.lane == _currentLane;
      final bool intersectsCar =
          hole.progress <= collisionLine && hole.progress + holeHeight >= collisionLine;
      if (laneMatch && intersectsCar) {
        _isGameOver = true;
        _gameLoopTimer?.cancel();
        break;
      }
    }
  }

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }
}
