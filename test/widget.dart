import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chessbotsmobile/main.dart';

void main() {
  testWidgets('Loading page displayed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    // check for loading screen
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
