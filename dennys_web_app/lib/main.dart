import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dennys_web_app/logger/logger.dart';
import 'package:dennys_web_app/login/login_page.dart';
import 'package:dennys_web_app/register/registration_page.dart';
import 'package:dennys_web_app/profile/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
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
            home: HomePage(),
        );
    }
}

class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
    final ManualResist dataService = ManualResist();
    final Node sample = Node(
        title: 'Sample Node Title',
        children: ['Child1', 'Child2', 'Child3'],
        status: 'InProgress',
        description: 'This is a description for the sample node.',
    );
  }
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
        '2': [4, 5],
        '3': [],
      },
      tasks: {
        '1': 'Task 1',
        '2': 'Task 2',
        '3': 'Task 3',
        '4': 'Task 4',
        '5': 'Task 5',
      },
    );
  }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: const Text('Firestore Save Data')),
                body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            ElevatedButton(
                                onPressed: () {
                                    // ログイン状態を確認
                                    User? currentUser = FirebaseAuth.instance
                                        .currentUser;
                                    /*
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
                                    */
                                    if (currentUser == null) {
                                        // ログインしていない場合、ログインページに移動
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => LoginPage()),
                                        );
                                    } else {
                                        // ログインしている場合、UserModelページに移動
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => UserModelPage(user: currentUser)),
                                        );
                                    }
                                },
                                child: const Text('Auth State'),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () {
                                    // 登録ページ
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => RegistrationPage()),
                                    );
                                },
                                child: const Text('Register'),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
