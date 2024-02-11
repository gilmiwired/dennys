import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dennys_web_app/login/login_page.dart';
//import 'package:dennys_web_app/register/registration_page.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';
import 'package:dennys_web_app/profile/user_data.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:dennys_web_app/Screen/Home.dart';

import 'package:dennys_web_app/game/test_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  // Removed empty class body
  @override
  void initState() {
    super.initState();
    // Initialization code here
  }

  // Step 1: Define the controller for the TextField
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController
        .dispose(); // Don't forget to dispose the controller when not in use
    super.dispose();
  }

  Future<void> _onButtonPressed() async {
    // Retrieve the value from the TextField
    String inputValue = _textController.text;
    await GlobalTree.initialize(title: "My Task Tree", isAsync: true);
    GlobalTree myTree = GlobalTree.instance;
    Node? rootNode = myTree.nodeList["1"];

    if (rootNode != null) {
      myTree.assignCoordinates(rootNode);
    }
    myTree.displayAllNodes();
    myTree.printNodeList();
    print("Input Value: $inputValue");
    // You can call any other specific function here using the inputValue
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Save Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Check login state
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) {
                  // Navigate to login page if not logged in
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  // Navigate to UserModelPage if logged in
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => UserModelPage(user: currentUser)),
                  );
                }
              },
              child: const Text('Auth State'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to registration page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BuildGame()),
                );
              },
              child: const Text('Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Initialize the GlobalTree
                GlobalTree.initialize(
                  title: "My Task Tree",
                  tree: {
                    '1': [2, 3, 4, 5, 6],
                    '2': [7, 8, 9],
                    '3': [10, 11, 12],
                    '4': [13, 14],
                    '5': [15, 16]
                  },
                  tasks: {
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
                    '16': '効果音'
                  },
                );

                GlobalTree myTree = GlobalTree.instance;

                Node? rootNode = myTree.nodeList["1"];

                if (rootNode != null) {
                  myTree.assignCoordinates(rootNode);
                }
                myTree.displayAllNodes();
              },
              child: const Text('Game'),
            ),

            // Step 2: Add the TextField to the Column
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter some text here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Step 3: Add the button
            ElevatedButton(
              onPressed: _onButtonPressed,
              child: const Text('Submit Text'),
            ),
          ],
        ),
      ),
    );
  }
}
