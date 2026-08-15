// 上杉暗号の対応表と、暗号化/復号化のロジックをまとめたモデル

// "い" = table[0][0]
// 上杉暗号が登場したのは江戸時代。当然元の表は1始まりだから一旦それを考慮して求めるプログラムが必要になる
class UesugiCipher {
  UesugiCipher._();

  static const List<List<String>> table = [
    ["い", "ろ", "は", "に", "ほ", "へ", "と"],
    ["ち", "り", "ぬ", "る", "を", "わ", "か"],
    ["よ", "た", "れ", "そ", "つ", "ね", "な"],
    ["ら", "む", "う", "い", "の", "お", "く"],
    ["や", "ま", "け", "ふ", "こ", "え", "て"],
    ["あ", "さ", "き", "ゆ", "め", "み", "し"],
    ["ゑ", "ひ", "も", "せ", "す", "ん", " "],
  ];

  // ひらがな平文 -> 暗号文（"行番号列番号" のリスト）
  static List<String> encode(String text) {
    final result = <String>[];

    // 半角空白文字に統一
    text = text.replaceAll("　", " ");

    // 1. 平文を1文字ずつ処理
    for (final char in text.split('')) {
      bool found = false;

      for (int i = 0; i < table.length; i++) {
        for (int j = 0; j < table[i].length; j++) {
          if (table[i][j] == char) {
            result.add('${i + 1}${j + 1}');
            found = true;
            break;
          }
        }
        if (found) break;
      }

      if (!found) {
        throw FormatException('対応表にない文字が含まれています: "$char"');
      }
    }

    return result;
  }

  // 暗号文（数字）-> ひらがな平文
  static String decode(String text) {
    // 空欄を全て削除して文字だけの状態にする
    final cleaned = text.replaceAll(" ", "").replaceAll("　", "");

    if (cleaned.length % 2 != 0) {
      throw const FormatException('暗号文の桁数が正しくありません');
    }

    final buffer = StringBuffer();

    // 2文字ずつ取り出す(行番号・列番号) -> ループは+2回
    for (int i = 0; i < cleaned.length; i += 2) {
      final row = int.parse(cleaned[i]);
      final col = int.parse(cleaned[i + 1]);

      if (row < 1 || row > table.length || col < 1 || col > table[row - 1].length) {
        throw FormatException('範囲外の数字です: $row$col');
      }

      // tableは0始まりなので-1して対応する文字を取得
      buffer.write(table[row - 1][col - 1]);
    }

    return buffer.toString();
  }
}
