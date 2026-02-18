import 'package:flutter/material.dart';

import 'src/widgets/game_screen.dart';

void main() {
  runApp(const LaneEscapeApp());
}

class LaneEscapeApp extends StatelessWidget {
  const LaneEscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lane Escape',
      theme: ThemeData.dark(useMaterial3: true),
      home: const GameScreen(),
    );
  }
}
