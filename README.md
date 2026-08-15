# uesugicipher（上杉暗号翻訳アプリ）

戦国時代に上杉謙信が用いたと伝わる「上杉暗号」で、ひらがなの平文と数字の暗号文を相互に変換する Flutter アプリです。

## 上杉暗号について

いろは47文字を7×7の表に並べ、各文字を「行番号・列番号」の2桁の数字に置き換える換字式暗号です。

```
1行目: い ろ は に ほ へ と
2行目: ち り ぬ る を わ か
3行目: よ た れ そ つ ね な
4行目: ら む う ゐ の お く
5行目: や ま け ふ こ え て
6行目: あ さ き ゆ め み し
7行目: ゑ ひ も せ す ん （空白）
```

例：「い」→ `11`、「ろ」→ `12`

## 機能

- **エンコード**：ひらがなの文章を数字の暗号文に変換
- **デコード**：数字の暗号文をひらがなの文章に変換
- 出力結果のワンタップコピー
- ライト/ダークテーマに対応

## 動作環境

- Flutter SDK（Dart ^3.12.2）

## セットアップ

```bash
flutter pub get
flutter run
```

## アーキテクチャ

MVC（Model / View / Controller）で構成しています。

```
lib/
├── main.dart                    # エントリーポイント（MyApp / テーマ設定）
├── model/
│   └── uesugi.dart               # Model: 上杉暗号の対応表とエンコード/デコードのロジック
├── Controller/
│   └── cipher_controller.dart    # Controller: Modelを操作し、Viewに状態を通知(ChangeNotifier)
└── screen/
    └── home_screen.dart          # View: 入力/出力の表示とユーザー操作の受け付け
```

- **Model**（`UesugiCipher`）：暗号表の定義と `encode` / `decode` の純粋なロジックのみを持つ
- **Controller**（`CipherController`）：`ChangeNotifier` でモードや出力結果、エラーメッセージなどの状態を保持し、Modelを呼び出す
- **View**（`HomeScreen`）：`ListenableBuilder` で Controller を監視し、UIの描画とユーザー入力の受け付けのみを行う
