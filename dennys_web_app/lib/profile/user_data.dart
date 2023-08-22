import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dennys_web_app/login/login_page.dart';


class UserModelPage extends StatelessWidget {
  final User user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModelPage({required this.user});

  Future<void> addTestDataToFirestore(User user) async {
    try {
      // ユーザのドキュメントにtreeとtasksのサブコレクションを追加
      await _firestore.collection('users').doc(user.uid).collection('tree').add({
        'data': tree,
      });
      await _firestore.collection('users').doc(user.uid).collection('tasks').add({
        'data': tasks,
      });
    } catch (e) {
      print(e);
    }
  }

  final Map<String, List<int>> tree = {
    '1': [2, 3, 4, 5, 6],
    '2': [7, 8, 9],
    '3': [10, 11, 12],
    '4': [13, 14],
    '5': [15, 16],
    '6': [17, 18]
  };

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
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
            SizedBox(height: 10),
            Text('Name: ${user.displayName ?? 'N/A'}'),
            Text('Email: ${user.email ?? 'N/A'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addTestDataToFirestore(user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data added successfully!')),
                );
              },
              child: Text('Add Test Data to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
