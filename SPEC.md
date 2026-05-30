# Spec: Flutter Splash & Home App

## Objective

Flutter (Android / iOS) の学習・デモ用アプリ。  
go_router でルーティング、Riverpod で状態管理を行う最小構成のベースプロジェクト。

**ユーザーストーリー:**
- アプリを起動すると Splash 画面が表示され、3秒後に自動的に Home 画面へ遷移する
- Home 画面はウェルカムメッセージと将来の機能拡張用のプレースホルダー UI を表示する

**成功基準:**
- [x] Android エミュレータで `flutter run` が成功する
- [x] iOS シミュレータで `flutter run` が成功する
- [x] Splash 画面が 3 秒表示された後、Home 画面に遷移する
- [x] go_router で `/splash` → `/home` のルーティングが機能する
- [x] Riverpod Provider が最低 1 つ定義・使用されている
- [x] `flutter analyze` がエラーゼロで完了する
- [x] `flutter test` が全件パスする

## Tech Stack

| ツール | バージョン |
|---|---|
| Flutter | >= 3.24.0 (stable) |
| Dart | >= 3.5.0 |
| flutter_riverpod | ^2.6.1 |
| riverpod_annotation | ^2.3.5 |
| go_router | ^14.6.2 |
| build_runner | ^2.4.13 |
| riverpod_generator | ^2.4.3 |
| flutter_lints | ^4.0.0 |

## Commands

```bash
# プロジェクト作成（初回のみ）
flutter create --org com.example my_flutter_app

# 依存パッケージ取得
flutter pub get

# コード生成（Riverpod アノテーション）
dart run build_runner build --delete-conflicting-outputs

# コード生成（ウォッチモード）
dart run build_runner watch --delete-conflicting-outputs

# 開発実行
flutter run

# 静的解析
flutter analyze

# テスト実行
flutter test

# Android ビルド
flutter build apk --release

# iOS ビルド
flutter build ios --release --no-codesign
```

## Project Structure

```
my_flutter_app/
├── lib/
│   ├── main.dart                  # エントリーポイント（ProviderScope ラップ）
│   ├── app.dart                   # MaterialApp.router の定義
│   ├── router/
│   │   └── router.dart            # go_router の GoRouter 定義
│   └── features/
│       ├── splash/
│       │   ├── splash_screen.dart          # Splash 画面 Widget
│       │   └── splash_notifier.dart        # 遷移タイミング制御 Provider
│       └── home/
│           ├── home_screen.dart            # Home 画面 Widget
│           └── home_notifier.dart          # Home 画面用 Provider（将来拡張用）
├── test/
│   ├── features/
│   │   ├── splash/
│   │   │   ├── splash_screen_test.dart
│   │   │   └── splash_notifier_test.dart
│   │   └── home/
│   │       └── home_screen_test.dart
│   └── router/
│       └── router_test.dart
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## Code Style

### ファイル命名
- ファイル名: `snake_case.dart`
- クラス名: `PascalCase`
- プロバイダー変数名: `camelCase` + `Provider` サフィックス

### Riverpod パターン（riverpod_annotation 使用）

```dart
// splash_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_notifier.g.dart';

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  bool build() => false; // isCompleted

  Future<void> waitAndComplete() async {
    await Future.delayed(const Duration(seconds: 3));
    state = true;
  }
}
```

### go_router パターン

```dart
// router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    ],
  );
}
```

### Widget パターン

```dart
// splash_screen.dart
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await ref.read(splashNotifierProvider.notifier).waitAndComplete();
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 16),
            Text('My Flutter App', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
```

### 規約
- `const` コンストラクタを積極的に使用する
- Widget は小さく保ち、1 ファイルに 1 つのメイン Widget
- Provider は feature ディレクトリ内に配置する
- `BuildContext` を async gap をまたいで使う場合は `mounted` チェックを必ず行う

## Testing Strategy

| テストレベル | フレームワーク | カバレッジ対象 |
|---|---|---|
| Unit | `flutter_test` | Provider の状態変化ロジック |
| Widget | `flutter_test` | 各画面の描画・キー要素の存在確認 |
| Integration | （今回は対象外） | - |

**テスト配置:** `test/` 以下に `lib/` と同じ構造でミラーリング

**最低限書くテスト:**
1. `SplashScreen` が FlutterLogo とアプリ名テキストを表示する
2. `HomeScreen` がウェルカムメッセージを表示する
3. `SplashNotifier` が `waitAndComplete()` 呼び出し後に `state = true` になる

## Boundaries

**Always:**
- `flutter analyze` をコミット前に実行してエラーゼロを確認する
- `riverpod_annotation` でコード生成を使う（手書き Provider は作らない）
- `mounted` チェックを async gap をまたぐ `BuildContext` 操作に必ず付ける
- `const` コンストラクタを使える場所では必ず使う

**Ask first:**
- 新しい外部パッケージの追加
- ディレクトリ構造の変更
- Flutter バージョンのアップグレード
- 認証やデータ永続化など新機能の追加

**Never:**
- `flutter_riverpod` の `ref.read` を `build()` メソッド内で使う
- `GlobalKey` を過度に使う（go_router に任せる）
- プラットフォーム固有コードを `lib/` に混在させる（`platform/` に分離する）
- テストをスキップする（`// TODO: add test` は認めない）

## Open Questions

- アプリ名は `my_flutter_app` で良いか？（変更する場合は実装前に確認）
- ~~Splash 画面の待機時間は 2 秒で良いか？~~ → **3秒に決定**
- ~~Home 画面のカラーテーマ（Material 3 デフォルトで進めるか？）~~ → **Material 3 デフォルトに決定**
- ~~iOS の Bundle ID / Android の applicationId のドメイン名（`com.example` のままで良いか？）~~ → **com.example のままに決定**
