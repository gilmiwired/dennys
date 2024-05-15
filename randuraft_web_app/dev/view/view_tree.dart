import 'package:flutter/material.dart';
import 'package:randuraft_web_app/global_setting/global_tree.dart';

class View_Tree extends StatefulWidget {
  const View_Tree({super.key});

  @override
  _View_Tree createState() => _View_Tree();
}

class _View_Tree extends State<View_Tree> {
  final Map<String, List<int>> tree = {
    '1': [2, 3, 4, 5, 6],
    '2': [7, 8, 9],
    '3': [10, 11, 12],
    '4': [13, 14],
    '5': [15, 16],
    '6': [17, 18]
  };

  // Tasks data
  final Map<String, String> tasks = {
    '1': 'ゲームを作る',
    '2': 'デザイン',
    '3': 'プログラム',
    '4': 'グラフィックス',
    '5': 'サウンド',
    '6': 'テスト',
    '7': 'コンセプト',
    '8': 'キャラ・ストーリー',
    '9': 'ルール・メカニクス',
    '10': 'エンジン選択',
    '11': 'キャラ動き',
    '12': 'ロジック・AI',
    '13': 'キャラ・背景アート',
    '14': 'アニメーション',
    '15': 'BGM',
    '16': '効果音',
    '17': 'バグチェック',
    '18': 'ユーザーテスト'
  };

  @override
  Widget build(BuildContext context) {
    GlobalTree.initialize(title: 'SomeUniqueKey', tree: tree, tasks: tasks);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tree View Example')),
        body: TreeView(globalTree: GlobalTree.instance),
      ),
    );
  }
}
