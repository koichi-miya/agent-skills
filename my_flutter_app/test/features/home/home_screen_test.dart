import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen shows welcome message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeScreen()),
      ),
    );
    expect(find.text('Welcome to My Flutter App'), findsOneWidget);
  });

  testWidgets('HomeScreen has AppBar with title Home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomeScreen()),
      ),
    );
    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
  });
}
