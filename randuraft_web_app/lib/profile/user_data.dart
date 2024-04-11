import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randuraft_web_app/login/login_page.dart';
import 'package:randuraft_web_app/global_setting/global_tree.dart';

class UserModelPage extends StatefulWidget {
  final User user;

  const UserModelPage({super.key, required this.user});

  @override
  _UserModelPageState createState() => _UserModelPageState();
}

class _UserModelPageState extends State<UserModelPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              await FirebaseAuth.instance.signOut();
              navigator.pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.user.photoURL!),
              ),
            const SizedBox(height: 10),
            Text('Name: ${widget.user.displayName ?? 'N/A'}'),
            Text('Email: ${widget.user.email ?? 'N/A'}'),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title here',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                String title = _titleController.text;
                GlobalTree.initialize(
                  title: title,
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
                var globalTree = GlobalTree.instance;
                await globalTree.addDataToFirestore(widget.user);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Data added successfully!')),
                );
              },
              child: const Text('Add Test Data to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
