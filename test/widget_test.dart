import 'package:flutter_test/flutter_test.dart';

import 'package:snake_game/main.dart';

void main() {
  testWidgets('Snake Game smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SnakeApp());

    expect(find.textContaining('Score: 0'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Restart'), findsWidgets);
  });

  testWidgets('Snake Game start functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const SnakeApp());

    await tester.tap(find.text('Start'));
    await tester.pump();

    expect(find.text('Pause'), findsOneWidget);
  });
}
