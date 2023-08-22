import 'package:flutter/material.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Addition Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // GlobalTreeの初期化
    GlobalTree.initialize(
      key: 'SomeUniqueKey',
      tree: {
        '1': [2, 3],
        '2': [],
        '3': [],
      },
      tasks: {
        '1': 'Task 1',
        '2': 'Task 2',
        '3': 'Task 3',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Node Addition Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // ノードを追加
            GlobalTree.instance.addNode("New Task", "2", insertAschild: true);

            // 結果をコンソールに表示
            GlobalTree.instance.printNodeList();
          },
          child: Text('Add Node and Print Tree'),
        ),
      ),
    );
  }
}
