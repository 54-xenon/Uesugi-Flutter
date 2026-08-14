import 'package:flutter/material.dart';
// 上杉暗号の対応表をインポート
import 'uesugi.dart';

void main() {
  runApp(const MyApp());
}

// ignore: camel_case_types
enum Mode { encord, decode }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '上杉暗号翻訳アプリ',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: '上杉暗号翻訳'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ラジオボタンの状態
  Mode? _selectedMode = Mode.encord;

  // テキストのコントローラ
  final _controller = TextEditingController();

  // 出力欄に表示する文字列
  String _outputText = "出力結果が表示されます";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: .spaceEvenly,
            children: [
              // 出力表示欄
              Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                height: 200,
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(25),
                  child: Text(_outputText, style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 8),

              // 入力用のTextFild
              TextField(
                // タップした時の表示するキーボードのタイプ
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "文字をここに入力",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                controller: _controller,
              ),
              SizedBox(height: 8),

              // 暗号/複合を選択するプルダウンメニュー
              RadioGroup<Mode>(
                groupValue: _selectedMode,
                onChanged: (Mode? value) {
                  setState(() {
                    _selectedMode = value;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // エンコード
                    Expanded(
                      child: RadioListTile<Mode>(
                        value: Mode.encord,
                        title: const Text("エンコード"),
                      ),
                    ),
                    // デコード
                    Expanded(
                      child: RadioListTile<Mode>(
                        value: Mode.decode,
                        title: const Text("デコード"),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),
              // 実行ボタン
              MaterialButton(
                onPressed: _selectedMode == Mode.encord
                    ? () {
                        final encordResult = encord(_controller.text);
                        setState(() {
                          // 前の結果が残っている場合 -> 初期化する
                          if (_outputText.isNotEmpty) {
                            _outputText = "";
                          }
                          _outputText = encordResult.join(' ');
                        });
                      }
                    : () {
                        final decordResult = decord(_controller.text);
                        setState(() {
                          // 結果を出力するWidgetの中身を更新する
                          if (_outputText.isNotEmpty) {
                            _outputText = "";
                          }
                          _outputText = decordResult.toString();
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow),
                        SizedBox(width: 3),
                        Text("実行"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// エンコード

List<String> encord(String text) {
  // 複合化されてる文字列
  final cipherResult = <String>[];

  // 半角空白文字に統一
  text = text.replaceAll("　", " ");
  // 1. 平文を1文字ずつ処理
  for (var char in text.split('')) {
    bool found = false;

    for (int i = 0; i < uesugiList.length; i++) {
      for (int j = 0; j < uesugiList[i].length; j++) {
        if (uesugiList[i][j] == char) {
          cipherResult.add('${i + 1}${j + 1}');
          found = true;
          break;
        }
      }
      if (found) {
        break;
      }
    }
  }

  return cipherResult;
}

String decord(String text) {
  String result = "";

  // 空欄を全て削除して文字だけの状態にする(引数textからデータを持ってくる)
  String cleand = text.replaceAll(" ", "").replaceAll("　", "");

  // forループで探索する -> 2つの数字で1文字だからループは+2回
  for (int i = 0; i < cleand.length; i += 2) {
    // 2文字ずつ取り出す(行番号・列番号)
    int row = int.parse(cleand[i]);
    int col = int.parse(cleand[i + 1]);

    // uesugiListは0始まりなので-1して対応する文字を取得
    result += uesugiList[row - 1][col - 1];
  }

  return result;
}
