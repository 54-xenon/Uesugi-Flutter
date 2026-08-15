import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Controller/cipher_controller.dart';

// View: 入力/出力の表示とユーザー操作の受け付けのみを担当する
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // UIを操作するコントローラ
  final _cipherController = CipherController();

  // テキストのコントローラ
  final _textController = TextEditingController();

  @override
  void dispose() {
    _cipherController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _showErrorIfAny(BuildContext context) {
    final message = _cipherController.consumeErrorMessage();
    if (message == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    });
  }

  void _copyOutput(BuildContext context) {
    final text = _cipherController.outputText;
    if (text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("コピーしました"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: Center(
                  child: ListenableBuilder(
                    listenable: _cipherController,
                    builder: (context, _) {
                      _showErrorIfAny(context);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16,
                        children: [
                          // 出力表示欄
                          Card(
                            elevation: 0,
                            color: colorScheme.surfaceContainerHigh,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "出力結果",
                                        style: textTheme.labelLarge?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () => _copyOutput(context),
                                        icon: const Icon(Icons.copy_rounded),
                                        iconSize: 20,
                                        visualDensity: VisualDensity.compact,
                                        tooltip: "コピー",
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(minHeight: 250),
                                    child: SelectableText(
                                      // textコントローラーからデータを取得しているところ
                                      _cipherController.outputText,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 入力用のTextFild
                          TextField(
                            controller: _textController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 7,
                            minLines: 5,
                            style: textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: "入力",
                              hintText: "文字をここに入力",
                              filled: true,
                              fillColor: colorScheme.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),

                          // 暗号/複合を選択するセグメントボタン
                          SegmentedButton<CipherMode>(
                            segments: const [
                              ButtonSegment(
                                value: CipherMode.encode,
                                label: Text("エンコード"),
                                icon: Icon(Icons.lock_outline_rounded),
                              ),
                              ButtonSegment(
                                value: CipherMode.decode,
                                label: Text("デコード"),
                                icon: Icon(Icons.lock_open_rounded),
                              ),
                            ],
                            selected: {_cipherController.mode},
                            onSelectionChanged: (selection) {
                              _cipherController.setMode(selection.first);
                            },
                            style: SegmentedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),

                          // 実行ボタン
                          FilledButton.icon(
                            onPressed: () => _cipherController.run(_textController.text),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text("実行"),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
