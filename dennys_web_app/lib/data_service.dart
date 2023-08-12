import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveToFirestore() async {
    final contentRef = firestore.collection('users').doc('user_ID').collection('content');
    // 以下、先程と同様のコード
    
    // Tree data
    final tree = [
      [1, [2, 3, 4, 5, 6]],
      [2, [7, 8, 9]],
      [3, [10, 11, 12]],
      [4, [13, 14]],
      [5, [15, 16]],
      [6, [17, 18]]
    ];

    // Tasks data
    final tasks = {
      1: "ゲームを作る",
      2: "デザイン",
      3: "プログラム",
      4: "グラフィックス",
      5: "サウンド",
      6: "テスト",
      7: "コンセプト",
      8: "キャラ・ストーリー",
      9: "ルール・メカニクス",
      10: "エンジン選択",
      11: "キャラ動き",
      12: "ロジック・AI",
      13: "キャラ・背景アート",
      14: "アニメーション",
      15: "BGM",
      16: "効果音",
      17: "バグチェック",
      18: "ユーザーテスト"
    };

    for (var item in tree) {
      final id = item[0];
      final children = item[1];
      await contentRef.doc('ID$id').set({
        'title': tasks[id],
        'children': children,
        'status': "do",  // ここは適宜変更してください
        'description': "説明"  // こちらも適宜変更
      });
    }

    print('Data saved to Firestore!');
  }

}

