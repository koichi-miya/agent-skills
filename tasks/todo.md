# TODO: Flutter Splash & Home App

**Spec:** [SPEC.md](../SPEC.md) | **Plan:** [plan.md](./plan.md)

---

## Task 1: プロジェクト生成・依存設定 ✅ DONE

- [x] `flutter create --org com.example my_flutter_app` を実行
- [x] `pubspec.yaml` に dependencies を追記（flutter_riverpod, riverpod_annotation, go_router）
- [x] `pubspec.yaml` に dev_dependencies を追記（build_runner, riverpod_generator, flutter_lints）
- [x] `flutter pub get` を実行
- [x] `analysis_options.yaml` を flutter_lints 推奨設定に更新
- [x] `lib/main.dart` のデフォルトカウンターを削除して暫定版 ProviderScope に置き換え
- [x] `dart run build_runner build --delete-conflicting-outputs` を実行
- [x] `flutter analyze` でエラーゼロを確認

**✅ チェックポイント A:** `flutter analyze` がクリーンな状態

---

## Task 2: Home画面（単体スライス） ✅ DONE

- [x] `lib/features/home/home_notifier.dart` を作成（@riverpod HomeNotifier）
- [x] `dart run build_runner build` を実行（home_notifier.g.dart を生成）
- [x] `lib/features/home/home_screen.dart` を作成（ConsumerWidget, ウェルカムメッセージ）
- [x] `test/features/home/home_screen_test.dart` を作成・実行
- [x] `flutter analyze` でエラーゼロを確認

**✅ チェックポイント B:** `flutter test test/features/home/` が PASS

---

## Task 3: Splash + Router + 全体結合 ✅ DONE（実機確認は Task 4 で実施）

- [x] `lib/features/splash/splash_notifier.dart` を作成（waitAndComplete, 3秒待機）
- [x] `lib/features/splash/splash_screen.dart` を作成（FlutterLogo + アプリ名, mounted チェックあり）
- [x] `lib/router/router.dart` を作成（GoRouter, /splash → /home）
- [x] `dart run build_runner build` を実行（全 .g.dart を更新）
- [x] `lib/app.dart` を作成（MaterialApp.router, Material 3 テーマ）
- [x] `lib/main.dart` を更新（ProviderScope(child: App())）
- [x] `test/features/splash/splash_screen_test.dart` を作成・実行
- [x] `test/features/splash/splash_notifier_test.dart` を作成・実行
- [x] `test/router/router_test.dart` を作成・実行
- [x] `flutter test` で全件パスを確認
- [x] `flutter analyze` でエラーゼロを確認
- [ ] `flutter run` で Splash → Home 遷移を目視確認（Task 4 で実施）

**✅ チェックポイント C:** 全テスト PASS + 実機動作確認済み

---

## Task 4: 最終検証 ✅ DONE

- [x] Android エミュレータで `flutter run` を実行して動作確認
- [x] iOS シミュレータで `flutter run` を実行して動作確認
- [x] `flutter analyze` で最終確認（エラーゼロ）
- [x] `flutter test` で最終確認（全件 PASS）
- [x] SPEC.md の成功基準チェックリストをすべてチェック済みに更新
