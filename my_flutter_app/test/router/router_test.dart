import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/router/router.dart';

void main() {
  test('router initial location is /splash', () {
    final container = ProviderContainer();
    final router = container.read(routerProvider);
    expect(
      router.routeInformationProvider.value.uri.toString(),
      '/splash',
    );
    container.dispose();
  });
}
