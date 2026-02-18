import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../controller/game_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GameController()..start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (DragEndDetails details) {
          final double? velocity = details.primaryVelocity;
          if (velocity == null || velocity == 0) return;
          if (velocity > 0) {
            _controller.swipeRight();
          } else {
            _controller.swipeLeft();
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: <Widget>[
                const Positioned.fill(child: _RoadBackground()),
                Positioned.fill(
                  child: _GameWorld(controller: _controller),
                ),
                if (_controller.isGameOver)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.75),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'Game Over',
                              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: _controller.restart,
                              child: const Text('Restart'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RoadBackground extends StatelessWidget {
  const _RoadBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: SvgPicture.asset(
            'assets/images/road.svg',
            fit: BoxFit.cover,
          ),
        ),
        CustomPaint(
          painter: _RoadEdgePainter(),
        ),
      ],
    );
  }
}

class _RoadEdgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    final double leftEdgeX = size.width * 0.18;
    final double rightEdgeX = size.width * 0.82;

    canvas.drawLine(Offset(leftEdgeX, 0), Offset(leftEdgeX, size.height), linePaint);
    canvas.drawLine(Offset(rightEdgeX, 0), Offset(rightEdgeX, size.height), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameWorld extends StatelessWidget {
  const _GameWorld({required this.controller});

  final GameController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double laneWidth = width / GameController.laneCount;

        double laneCenterX(int lane) => (lane + 0.5) * laneWidth;

        return Stack(
          children: <Widget>[
            for (final hole in controller.holes)
              Positioned(
                top: hole.progress * height,
                left: laneCenterX(hole.lane) - laneWidth * 0.35,
                width: laneWidth * 0.7,
                height: height * GameController.holeHeight,
                child: const _HoleWidget(),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              bottom: height * 0.05,
              left: laneCenterX(controller.currentLane) - laneWidth * 0.28,
              width: laneWidth * 0.56,
              height: height * 0.16,
              child: SvgPicture.asset(
                'assets/images/car.svg',
                fit: BoxFit.contain,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HoleWidget extends StatelessWidget {
  const _HoleWidget();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Colors.black54, blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: const SizedBox.expand(),
    );
  }
}
