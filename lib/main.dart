import 'package:flutter/material.dart';

import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '上杉暗号翻訳アプリ',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light
        )
      ),
      
      // ナイトモード用のダークテーマを設定 -> システムの設定がナイトモードになった時にテーマを自動で切り替え
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        )
      ),
      home: const HomeScreen(title: '上杉暗号翻訳'),
    );
  }
}
