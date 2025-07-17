import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'level_editor.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LevelEditorScreen extends StatefulWidget {
  const LevelEditorScreen({super.key});

  @override
  State<LevelEditorScreen> createState() => _LevelEditorScreenState();
}

class _LevelEditorScreenState extends State<LevelEditorScreen> {
  final LevelEditorGame game = LevelEditorGame();

  void exportLevel() async {
    final jsonData = game.exportLevelToJson();
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/level_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(filePath);
    await file.writeAsString(jsonData);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('关卡已导出到 $filePath')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关卡编辑器')),
      body: Column(
        children: [
          Expanded(child: GameWidget(game: game)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: exportLevel,
              child: const Text('导出关卡'),
            ),
          ),
        ],
      ),
    );
  }
}
