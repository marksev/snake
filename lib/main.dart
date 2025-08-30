import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SnakeGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int boardSize = 20;
  static const double cellSize = 20.0;
  
  List<Offset> snake = [const Offset(10, 10)];
  Offset food = const Offset(5, 5);
  Direction direction = Direction.right;
  bool isGameRunning = false;
  bool isGameOver = false;
  bool isPaused = false;
  int score = 0;
  int bestScore = 0;
  Timer? gameTimer;

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadBestScore();
    _generateFood();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      snake = [const Offset(10, 10)];
      direction = Direction.right;
      isGameRunning = true;
      isGameOver = false;
      isPaused = false;
      score = 0;
    });
    _generateFood();
    
    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _moveSnake();
    });
  }

  void _pauseGame() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
      isPaused = true;
    });
  }

  void _resumeGame() {
    setState(() {
      isGameRunning = true;
      isPaused = false;
    });
    gameTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _moveSnake();
    });
  }

  void _resetGame() {
    gameTimer?.cancel();
    setState(() {
      snake = [const Offset(10, 10)];
      direction = Direction.right;
      isGameRunning = false;
      isGameOver = false;
      isPaused = false;
      score = 0;
    });
    _generateFood();
  }

  void _generateFood() {
    do {
      food = Offset(
        random.nextInt(boardSize).toDouble(),
        random.nextInt(boardSize).toDouble(),
      );
    } while (snake.contains(food));
  }

  void _moveSnake() {
    setState(() {
      Offset newHead;
      switch (direction) {
        case Direction.up:
          newHead = Offset(snake.first.dx, snake.first.dy - 1);
          break;
        case Direction.down:
          newHead = Offset(snake.first.dx, snake.first.dy + 1);
          break;
        case Direction.left:
          newHead = Offset(snake.first.dx - 1, snake.first.dy);
          break;
        case Direction.right:
          newHead = Offset(snake.first.dx + 1, snake.first.dy);
          break;
      }

      // Check wall collision
      if (newHead.dx < 0 || newHead.dx >= boardSize || 
          newHead.dy < 0 || newHead.dy >= boardSize) {
        _gameOver();
        return;
      }

      // Check self collision
      if (snake.contains(newHead)) {
        _gameOver();
        return;
      }

      snake.insert(0, newHead);

      // Check food collision
      if (newHead == food) {
        score++;
        if (score > bestScore) {
          bestScore = score;
          _saveBestScore();
        }
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  Future<void> _loadBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bestScore = prefs.getInt('best_score') ?? 0;
    });
  }

  Future<void> _saveBestScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('best_score', bestScore);
  }

  void _gameOver() {
    gameTimer?.cancel();
    setState(() {
      isGameRunning = false;
      isGameOver = true;
      isPaused = false;
    });
  }

  void _changeDirection(Direction newDirection) {
    if (!isGameRunning) return;
    
    // Prevent reversing into itself
    if ((direction == Direction.up && newDirection == Direction.down) ||
        (direction == Direction.down && newDirection == Direction.up) ||
        (direction == Direction.left && newDirection == Direction.right) ||
        (direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    
    setState(() {
      direction = newDirection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              _changeDirection(Direction.up);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              _changeDirection(Direction.down);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _changeDirection(Direction.left);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _changeDirection(Direction.right);
            } else if (event.logicalKey == LogicalKeyboardKey.space) {
              if (isGameRunning) {
                _pauseGame();
              } else if (isPaused) {
                _resumeGame();
              } else if (!isGameOver) {
                _startGame();
              }
            }
          }
          return KeyEventResult.handled;
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            if (!isGameRunning) return;
            
            double sensitivity = 3.0;
            if (details.delta.dx.abs() > details.delta.dy.abs()) {
              if (details.delta.dx > sensitivity) {
                _changeDirection(Direction.right);
              } else if (details.delta.dx < -sensitivity) {
                _changeDirection(Direction.left);
              }
            } else {
              if (details.delta.dy > sensitivity) {
                _changeDirection(Direction.down);
              } else if (details.delta.dy < -sensitivity) {
                _changeDirection(Direction.up);
              }
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                // Score Display
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.apple, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '$score',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '$bestScore',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Game Board
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (isGameRunning) {
                          // Do nothing when the game is running
                        } else if (isPaused) {
                          _resumeGame();
                        } else {
                          _startGame();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown, width: 4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomPaint(
                          size: Size(
                            boardSize * cellSize,
                            boardSize * cellSize,
                          ),
                          painter: GamePainter(
                            snake: snake,
                            food: food,
                            cellSize: cellSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Control Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isGameRunning
                            ? _pauseGame
                            : (isPaused ? _resumeGame : _startGame),
                        child: Text(
                          isGameRunning
                              ? 'Pause'
                              : (isPaused ? 'Resume' : 'Start'),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _resetGame,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                ),
                
                if (isGameOver)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Game Over!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Final Score: $score',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final double cellSize;

  GamePainter({
    required this.snake,
    required this.food,
    required this.cellSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw checkered background
    final Paint lightGreen = Paint()..color = const Color(0xFF8BC34A);
    final Paint darkGreen = Paint()..color = const Color(0xFF689F38);
    
    for (int i = 0; i < (size.width / cellSize).ceil(); i++) {
      for (int j = 0; j < (size.height / cellSize).ceil(); j++) {
        final rect = Rect.fromLTWH(
          i * cellSize,
          j * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, (i + j) % 2 == 0 ? lightGreen : darkGreen);
      }
    }

    // Draw food (red apple)
    final Paint foodPaint = Paint()..color = Colors.red;
    final Paint leafPaint = Paint()..color = Colors.green;
    
    final foodRect = Rect.fromLTWH(
      food.dx * cellSize + 2,
      food.dy * cellSize + 2,
      cellSize - 4,
      cellSize - 4,
    );
    canvas.drawOval(foodRect, foodPaint);
    
    // Draw apple leaf
    final leafRect = Rect.fromLTWH(
      food.dx * cellSize + cellSize * 0.6,
      food.dy * cellSize + 2,
      cellSize * 0.3,
      cellSize * 0.3,
    );
    canvas.drawOval(leafRect, leafPaint);

    // Draw snake
    final Paint snakePaint = Paint()..color = Colors.blue;
    final Paint eyePaint = Paint()..color = Colors.white;
    final Paint pupilPaint = Paint()..color = Colors.black;
    
    for (int i = 0; i < snake.length; i++) {
      final segment = snake[i];
      final segmentRect = Rect.fromLTWH(
        segment.dx * cellSize + 1,
        segment.dy * cellSize + 1,
        cellSize - 2,
        cellSize - 2,
      );
      
      // Draw snake segment with rounded corners
      canvas.drawRRect(
        RRect.fromRectAndRadius(segmentRect, const Radius.circular(6)),
        snakePaint,
      );
      
      // Draw eyes on head
      if (i == 0) {
        final double eyeSize = cellSize * 0.2;
        final double eyeOffset = cellSize * 0.25;
        
        // Left eye
        canvas.drawCircle(
          Offset(
            segment.dx * cellSize + eyeOffset,
            segment.dy * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        canvas.drawCircle(
          Offset(
            segment.dx * cellSize + eyeOffset,
            segment.dy * cellSize + eyeOffset,
          ),
          eyeSize * 0.6,
          pupilPaint,
        );
        
        // Right eye
        canvas.drawCircle(
          Offset(
            segment.dx * cellSize + cellSize - eyeOffset,
            segment.dy * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        canvas.drawCircle(
          Offset(
            segment.dx * cellSize + cellSize - eyeOffset,
            segment.dy * cellSize + eyeOffset,
          ),
          eyeSize * 0.6,
          pupilPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum Direction {
  up,
  down,
  left,
  right,
}