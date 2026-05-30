# Plan: Flutter Splash & Home App

**Spec:** [SPEC.md](../SPEC.md)  
**作成日:** 2026-05-30  
**方針:** 垂直スライス（1タスク = 1完結するパス）

---

## 依存グラフ

```
Task 1: プロジェクト生成・依存設定
    └─ Task 2: Home画面（単体スライス）
            └─ Task 3: Splash + Router + 全体結合
                    └─ Task 4: 最終検証
```

Task 2 は Task 3 に先行する（Home画面が存在しないとRouterが定義できない）。  
Task 3 完了まで実機動作確認はせず、Task 4 でまとめて行う。

---

## Task 1: プロジェクト生成・依存設定

**目的:** ビルドが通る最小限の Flutter プロジェクトを作る

### 実装内容

1. `flutter create --org com.example my_flutter_app` でプロジェクト生成
2. `pubspec.yaml` に依存パッケージを追記:
   - `flutter_riverpod: ^2.6.1`
   - `riverpod_annotation: ^2.3.5`
   - `go_router: ^14.6.2`
   - dev: `build_runner: ^2.4.13`, `riverpod_generator: ^2.4.3`, `flutter_lints: ^4.0.0`
3. `flutter pub get` を実行
4. `dart run build_runner build --delete-conflicting-outputs` で初回コード生成確認
5. `analysis_options.yaml` を flutter_lints 推奨設定に更新

### 変更ファイル

- `my_flutter_app/pubspec.yaml`
- `my_flutter_app/analysis_options.yaml`
- `my_flutter_app/lib/main.dart`（デフォルトカウンターを削除、ProviderScope のみ残す暫定版）

### 受け入れ条件

- [ ] `flutter pub get` がエラーなく完了する
- [ ] `dart run build_runner build` がエラーなく完了する
- [ ] `flutter analyze` がエラーゼロで完了する

### 検証コマンド

```bash
cd my_flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

---

## ✅ チェックポイント A（Task 1 完了後）

> `flutter analyze` がクリーンな状態でTask 2 に進む。  
> ここで analyze エラーが出る場合は pubspec.yaml や analysis_options.yaml を修正してから進む。

---

## Task 2: Home画面（単体スライス）

**目的:** ルーティングなしで Home 画面を単体で動作確認できる状態にする

### 実装内容

1. `lib/features/home/home_notifier.dart` を作成
   - `@riverpod` アノテーションで `HomeNotifier` を定義（将来拡張用、初期値は空文字 or bool）
2. `dart run build_runner build` でコード生成（`home_notifier.g.dart` 生成）
3. `lib/features/home/home_screen.dart` を作成
   - `ConsumerWidget` で「Welcome to My Flutter App」テキストを表示
   - `AppBar` にタイトル「Home」を設定
4. `test/features/home/home_screen_test.dart` を作成
   - `HomeScreen` が「Welcome to My Flutter App」を描画するテストを記述

### 変更ファイル

- `lib/features/home/home_notifier.dart`（新規）
- `lib/features/home/home_notifier.g.dart`（生成）
- `lib/features/home/home_screen.dart`（新規）
- `test/features/home/home_screen_test.dart`（新規）

### 受け入れ条件

- [ ] `flutter test test/features/home/` が PASS する
- [ ] `flutter analyze` がエラーゼロのまま

### 検証コマンド

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/features/home/
flutter analyze
```

---

## ✅ チェックポイント B（Task 2 完了後）

> Home画面のウィジェットテストが通った状態で Task 3 に進む。  
> テストが落ちる場合は HomeScreen の実装を修正してから進む。

---

## Task 3: Splash + Router + 全体結合

**目的:** アプリ起動 → Splash 3秒 → Home 遷移という完全なユーザーフローを実現する

### 実装内容

1. `lib/features/splash/splash_notifier.dart` を作成
   - `SplashNotifier` で `waitAndComplete()` を実装（3秒待機後 `state = true`）
2. `lib/features/splash/splash_screen.dart` を作成
   - `ConsumerStatefulWidget` で FlutterLogo + アプリ名を表示
   - `initState` で `_navigate()` を呼び出し
   - `waitAndComplete()` 完了後に `context.go('/home')`（`mounted` チェックあり）
3. `lib/router/router.dart` を作成
   - `@riverpod` で `GoRouter` を定義
   - `initialLocation: '/splash'`
   - `/splash` → `SplashScreen`、`/home` → `HomeScreen`
4. `dart run build_runner build` でコード生成（全 `.g.dart` を更新）
5. `lib/app.dart` を作成
   - `ref.watch(routerProvider)` で取得した GoRouter を `MaterialApp.router` に渡す
   - `theme: ThemeData(useMaterial3: true)` を設定
6. `lib/main.dart` を更新
   - `runApp(const ProviderScope(child: App()))` にする
7. テスト作成:
   - `test/features/splash/splash_screen_test.dart`（FlutterLogo とアプリ名の表示確認）
   - `test/features/splash/splash_notifier_test.dart`（`waitAndComplete()` 後に `state == true`）
   - `test/router/router_test.dart`（初期ルートが `/splash` であること）

### 変更ファイル

- `lib/features/splash/splash_notifier.dart`（新規）
- `lib/features/splash/splash_notifier.g.dart`（生成）
- `lib/features/splash/splash_screen.dart`（新規）
- `lib/router/router.dart`（新規）
- `lib/router/router.g.dart`（生成）
- `lib/app.dart`（新規）
- `lib/main.dart`（更新）
- `test/features/splash/splash_screen_test.dart`（新規）
- `test/features/splash/splash_notifier_test.dart`（新規）
- `test/router/router_test.dart`（新規）

### 受け入れ条件

- [ ] `flutter test` が全件 PASS する
- [ ] `flutter analyze` がエラーゼロのまま
- [ ] `flutter run` でアプリが起動し、Splash → Home 遷移が動作する

### 検証コマンド

```bash
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter analyze
flutter run
```

---

## ✅ チェックポイント C（Task 3 完了後）

> 全テストが通り、実機/シミュレータで動作確認できた状態で Task 4 に進む。  
> `flutter run` で Splash が 3 秒表示されてから Home に遷移することを目視確認する。

---

## Task 4: 最終検証

**目的:** SPEC.md の全成功基準を満たすことを確認する

### 実施内容

1. Android エミュレータで `flutter run` を実行し動作確認
2. iOS シミュレータで `flutter run` を実行し動作確認
3. `flutter analyze` でエラーゼロを最終確認
4. `flutter test` で全件パスを最終確認
5. SPEC.md の成功基準チェックリストを更新

### 受け入れ条件（SPEC.md 成功基準より）

- [ ] Android エミュレータで `flutter run` が成功する
- [ ] iOS シミュレータで `flutter run` が成功する
- [ ] Splash 画面が 3 秒表示された後、Home 画面に遷移する
- [ ] go_router で `/splash` → `/home` のルーティングが機能する
- [ ] Riverpod Provider が最低 1 つ定義・使用されている
- [ ] `flutter analyze` がエラーゼロで完了する
- [ ] `flutter test` が全件パスする

---

## リスクと対策

| リスク | 対策 |
|---|---|
| build_runner のバージョン競合 | `pub get` 時にエラーが出たらバージョン制約を緩める（`^` → `>=`） |
| go_router と riverpod の相互依存でコード生成が失敗 | router.dart の import 順序を確認。SplashScreen・HomeScreen のインポートが揃っているか確認 |
| iOS ビルドで CocoaPods エラー | `cd ios && pod install` を手動実行 |
| `mounted` チェック漏れによる警告 | `flutter analyze` で必ず検出されるため Task 毎に実行して早期発見 |
