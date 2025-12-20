import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({super.key});

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int boardSize = 20;
  static const double cellSize = 20;
  static const int baseSpeedMs = 220;

  final Random _random = Random();

  List<Point<int>> _snake = [];
  Point<int> _food = const Point(0, 0);
  Direction _direction = Direction.right;
  Timer? _ticker;
  bool _isRunning = false;
  bool _isGameOver = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _resetState() {
    _ticker?.cancel();
    _snake = [
      Point(boardSize ~/ 2, boardSize ~/ 2),
      Point(boardSize ~/ 2 - 1, boardSize ~/ 2),
    ];
    _direction = Direction.right;
    _isRunning = false;
    _isGameOver = false;
    _score = 0;
    _spawnFood();
    setState(() {});
  }

  void _startGame() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _isGameOver = false;
    });
    _scheduleTick();
  }

  void _pauseGame() {
    _ticker?.cancel();
    setState(() => _isRunning = false);
  }

  void _resumeGame() {
    if (_isRunning || _isGameOver) return;
    setState(() => _isRunning = true);
    _scheduleTick();
  }

  void _scheduleTick() {
    _ticker?.cancel();
    _ticker = Timer.periodic(_currentSpeed(), (_) => _tick());
  }

  Duration _currentSpeed() {
    final decreased = baseSpeedMs - min(_score * 5, 120);
    final milliseconds = max(80, decreased).toInt();
    return Duration(milliseconds: milliseconds);
  }

  void _tick() {
    if (!_isRunning) return;
    final newHead = _nextHead();

    if (_isWallHit(newHead) || _snake.contains(newHead)) {
      _gameOver();
      return;
    }

    setState(() {
      _snake = [newHead, ..._snake];
      if (newHead == _food) {
        _score++;
        _spawnFood();
        _scheduleTick();
      } else {
        _snake.removeLast();
      }
    });
  }

  Point<int> _nextHead() {
    final head = _snake.first;
    switch (_direction) {
      case Direction.up:
        return Point(head.x, head.y - 1);
      case Direction.down:
        return Point(head.x, head.y + 1);
      case Direction.left:
        return Point(head.x - 1, head.y);
      case Direction.right:
        return Point(head.x + 1, head.y);
    }
  }

  bool _isWallHit(Point<int> position) {
    return position.x < 0 ||
        position.y < 0 ||
        position.x >= boardSize ||
        position.y >= boardSize;
  }

  void _spawnFood() {
    Point<int> candidate;
    do {
      candidate = Point(
        _random.nextInt(boardSize),
        _random.nextInt(boardSize),
      );
    } while (_snake.contains(candidate));
    _food = candidate;
  }

  void _gameOver() {
    _ticker?.cancel();
    setState(() {
      _isRunning = false;
      _isGameOver = true;
    });
  }

  void _changeDirection(Direction newDirection) {
    if (!_isRunning) return;
    if (_isOpposite(_direction, newDirection)) return;
    setState(() => _direction = newDirection);
  }

  bool _isOpposite(Direction a, Direction b) {
    return (a == Direction.up && b == Direction.down) ||
        (a == Direction.down && b == Direction.up) ||
        (a == Direction.left && b == Direction.right) ||
        (a == Direction.right && b == Direction.left);
  }

  void _handleSwipe(DragUpdateDetails details) {
    if (details.delta.dx.abs() > details.delta.dy.abs()) {
      if (details.delta.dx > 0) {
        _changeDirection(Direction.right);
      } else {
        _changeDirection(Direction.left);
      }
    } else {
      if (details.delta.dy > 0) {
        _changeDirection(Direction.down);
      } else {
        _changeDirection(Direction.up);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardDimension = boardSize * cellSize;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sports_score, color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      Text(
                        'Score: $_score',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.tonal(
                    onPressed: _isRunning ? _pauseGame : _resumeGame,
                    child: Text(_isRunning ? 'Pause' : 'Resume'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _isGameOver ? _resetState : _startGame,
                        onPanUpdate: _handleSwipe,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F1115),
                            border: Border.all(color: const Color(0xFF1F8C3A), width: 3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomPaint(
                            painter: _SnakePainter(
                              snake: _snake,
                              food: _food,
                              cellSize: cellSize,
                              boardSize: boardSize,
                            ),
                            size: Size.square(boardDimension),
                          ),
                        ),
                      ),
                      if (!_isRunning && !_isGameOver)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Tap to start',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _startGame,
                                child: const Text('Start'),
                              ),
                            ],
                          ),
                        ),
                      if (_isGameOver)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.6),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Game Over',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Final score: $_score',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: _resetState,
                                    child: const Text('Restart'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _startGame,
                    child: const Text('Play'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.tonal(
                    onPressed: _resetState,
                    child: const Text('Restart'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnakePainter extends CustomPainter {
  _SnakePainter({
    required this.snake,
    required this.food,
    required this.cellSize,
    required this.boardSize,
  });

  final List<Point<int>> snake;
  final Point<int> food;
  final double cellSize;
  final int boardSize;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF1C1F26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i <= boardSize; i++) {
      final position = i * cellSize;
      canvas.drawLine(Offset(position, 0), Offset(position, size.height), gridPaint);
      canvas.drawLine(Offset(0, position), Offset(size.width, position), gridPaint);
    }

    final foodPaint = Paint()..color = Colors.redAccent;
    final foodRect = Rect.fromLTWH(
      food.x * cellSize + 2,
      food.y * cellSize + 2,
      cellSize - 4,
      cellSize - 4,
    );
    canvas.drawRect(foodRect, foodPaint);

    final snakePaint = Paint()..color = const Color(0xFF3DFF76);
    for (final segment in snake) {
      final rect = Rect.fromLTWH(
        segment.x * cellSize + 1,
        segment.y * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        snakePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SnakePainter oldDelegate) {
    return oldDelegate.snake != snake ||
        oldDelegate.food != food ||
        oldDelegate.cellSize != cellSize ||
        oldDelegate.boardSize != boardSize;
  }
}

enum Direction { up, down, left, right }
