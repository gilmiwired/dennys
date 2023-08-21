import 'package:dennys_web_app/Manual/Manual_Registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dennys_web_app/logger/logger.dart';
import 'firebase_options.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
    final ManualResist dataService = ManualResist();
    final Node sample = Node(
        title: 'Sample Node Title',
        children: ['Child1', 'Child2', 'Child3'],
        status: 'InProgress',
        description: 'This is a description for the sample node.',
    );
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
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: const Text('Firestore Save Data')),
                body: Center(
                    child: ElevatedButton(
                        onPressed: () {
                            GlobalTree.initialize(
                                key: 'SomeUniqueKey',
                                tree: tree,
                                tasks: tasks
                            );
                            var globalTree = GlobalTree.instance;
                            globalTree.printNodeList();
                            GlobalTree.instance.collectAllChildNodes("2");
                            globalTree.printNodeList();
                            sample.display();
                        },
                        child: const Text('Save Data to Firestore'),
                    ),
                ),
            ),
        );
    }
}