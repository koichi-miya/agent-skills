import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_notifier.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  bool build() => false;

  Future<void> waitAndComplete() async {
    await Future.delayed(const Duration(seconds: 3));
    state = true;
  }
}
