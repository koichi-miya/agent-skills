import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/app.dart';
import 'package:my_flutter_app/features/home/home_screen.dart';
import 'package:my_flutter_app/features/splash/splash_notifier.dart';
import 'package:my_flutter_app/features/splash/splash_screen.dart';

class _NeverCompletingSplashNotifier extends SplashNotifier {
  @override
  Future<void> waitAndComplete() => Completer<void>().future;
}

class _ImmediateCompletingSplashNotifier extends SplashNotifier {
  @override
  Future<void> waitAndComplete() async {
    // Yield one microtask so the widget tree finishes building before
    // state is modified (modifying providers during build is not allowed).
    await Future<void>.value();
    state = true;
  }
}

void main() {
  testWidgets('App uses real MaterialApp.router and shows SplashScreen initially',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashNotifierProvider
              .overrideWith(() => _NeverCompletingSplashNotifier()),
        ],
        child: const App(),
      ),
    );
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('App navigates from SplashScreen to HomeScreen after completion',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashNotifierProvider
              .overrideWith(() => _ImmediateCompletingSplashNotifier()),
        ],
        child: const App(),
      ),
    );

    // 初期フレーム: SplashScreen が表示される
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);

    // 非同期ナビゲーション完了を待つ
    await tester.pumpAndSettle();

    // ナビゲーション後: HomeScreen が表示される
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
