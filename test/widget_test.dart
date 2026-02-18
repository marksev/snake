import 'package:flutter_test/flutter_test.dart';

import 'package:lane_escape/main.dart';

void main() {
  testWidgets('shows game screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LaneEscapeApp());

    expect(find.text('Game Over'), findsNothing);
  });
}
