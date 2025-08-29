import 'package:flutter_test/flutter_test.dart';

import 'package:snake_game/main.dart';

void main() {
  testWidgets('Snake Game smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that both current and best scores start at 0
    expect(find.text('0'), findsNWidgets(2));
    
    // Verify that Start button is present
    expect(find.text('Start'), findsOneWidget);
    
    // Verify that Reset button is present
    expect(find.text('Reset'), findsOneWidget);
  });
  
  testWidgets('Snake Game start functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Tap the Start button
    await tester.tap(find.text('Start'));
    await tester.pump();
    
    // Verify that the button text changes to Pause
    expect(find.text('Pause'), findsOneWidget);
  });
}