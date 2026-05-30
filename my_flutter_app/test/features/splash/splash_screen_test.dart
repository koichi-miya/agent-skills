import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/splash/splash_notifier.dart';
import 'package:my_flutter_app/features/splash/splash_screen.dart';

class _NeverCompletingSplashNotifier extends SplashNotifier {
  @override
  Future<void> waitAndComplete() => Completer<void>().future;
}

void main() {
  testWidgets('SplashScreen shows FlutterLogo', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashNotifierProvider
              .overrideWith(() => _NeverCompletingSplashNotifier()),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );
    expect(find.byType(FlutterLogo), findsOneWidget);
  });

  testWidgets('SplashScreen shows app name', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashNotifierProvider
              .overrideWith(() => _NeverCompletingSplashNotifier()),
        ],
        child: const MaterialApp(home: SplashScreen()),
      ),
    );
    expect(find.text('My Flutter App'), findsOneWidget);
  });
}
