import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:practice_integration_test/main.dart' as app;

// 【注意事項】本テストは実際にPCとデバイス同士を接続しないとテストできません

// 以下、カウンターテストの実行コマンド
// fvm flutter test integration_test/app_test.dart -d［デバイスID］
// integration_testディレクトリ内全体のテストコードを実行したい場合
// fvm flutter test integration_test

// 【メモ】
// 最初テスト実行時、以下コマンド実行 → エラー！
// エラー内容① : Execution failed for task ‘:app:checkDebugAarMetadata‘
// エラー内容② : [!] Your project requires a newer version of the Kotlin Gradle plugin.
// 【エラー対処方法】
// エラー内容①対処 : app/build.gradleファイル内の「compileSdkVersion」を30 → 31に変更（変更後、エラー②が発生）
// エラー内容②対処 : build.gradleファイル内の「ext.kotlin_version」を1.3.50 → 1.6.0に変更
//【エラー対処後】
// fvm flutter test integration_test/app_test.dart -d［デバイスID］実行
// ※ 実行時はPCとAndroid［ASUS_Z017DA］同士を接続した状態
//「01:00 +1: All tests passed! 」

void main() {
  // 物理デバイスでテストを実行するシングルトンサービス
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'main.dart全体のテスト',
    () {
      testWidgets(
        'フローティングアクションボタンをタップし、カウンターを確認します',
        (tester) async {
          // main.dartのrunApp関数を起動
          app.main();
          // Widget Testerクラスを使用して、ウィジェットを操作してテスト実行
          // pumpAndSettleで画面の起動を待つ
          await tester.pumpAndSettle(Duration(seconds: 5));

          // カウンターが「0」から始まる事を確認します
          expect(find.text('0'), findsOneWidget);

          // タップするフローティングアクションボタンを検索します
          final Finder fab = find.byTooltip('Increment');

          // フローティングアクションのタップ動作を真似て、
          // デバイス上でタップが実行されます
          await tester.tap(fab);

          // デバイス上でタップが実行された後、
          // カウンターの値がIncrement（0 → 1）されるはずなので、
          // その間、結果を待ちます
          await tester.pumpAndSettle(Duration(seconds: 5));

          // フローティングアクションボタンをタップ後、
          // カウンターの値が0 → 1に変化したか確認します
          expect(find.text('1'), findsOneWidget);
        },
      );
    },
  );
}
