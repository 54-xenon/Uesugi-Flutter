import 'package:flutter/foundation.dart';

import '../model/uesugi.dart';

enum CipherMode { encode, decode }

// 画面(View)と上杉暗号モデルの橋渡しをするController
class CipherController extends ChangeNotifier {
  CipherMode _mode = CipherMode.encode;
  String _outputText = "出力結果が表示されます";
  String? _errorMessage;

  CipherMode get mode => _mode;
  String get outputText => _outputText;

  // Viewが表示し終わったら都度取り出して消費する
  String? consumeErrorMessage() {
    final message = _errorMessage;
    _errorMessage = null;
    return message;
  }

  void setMode(CipherMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    notifyListeners();
  }

  // 入力文字列を現在のモードに応じてエンコード/デコードする
  void run(String inputText) {
    try {
      _outputText = _mode == CipherMode.encode
          ? UesugiCipher.encode(inputText).join(' ')
          : UesugiCipher.decode(inputText);
    } on FormatException catch (e) {
      _errorMessage = _mode == CipherMode.encode
          ? "エラー: ひらがなのみを入力して下さい ($e)"
          : "エラー: 数字のみを入力して下さい ($e)";
    } catch (e) {
      _errorMessage = "エラー: $e";
    }

    notifyListeners();
  }
}
