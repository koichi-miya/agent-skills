import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/splash/splash_notifier.dart';

void main() {
  test('SplashNotifier initial state is false', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(splashNotifierProvider), false);
  });

  test('SplashNotifier state becomes true after waitAndComplete', () async {
    final container = ProviderContainer();
    // listen keeps the AutoDisposeNotifier alive during the 3-second wait
    final sub = container.listen(splashNotifierProvider, (_, __) {});
    await container.read(splashNotifierProvider.notifier).waitAndComplete();
    expect(container.read(splashNotifierProvider), true);
    sub.close();
    container.dispose();
  });
}
