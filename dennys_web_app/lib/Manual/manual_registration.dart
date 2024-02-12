import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dennys_web_app/logger/logger.dart';
import 'package:dennys_web_app/task_data_generator.dart';

class ManualResist {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveToFirestore() async {
    //データを保存する関数
    final contentRef =
        firestore.collection('users').doc('user_ID').collection('content');
    final userRef = firestore.collection('users').doc('user_ID');

    // Tree data
    final tree = {
      '1': [2, 3, 4, 5, 6],
      '2': [7, 8, 9],
      '3': [10, 11, 12],
      '4': [13, 14],
      '5': [15, 16],
      '6': [17, 18]
    };

    // Tasks data
    final tasks = {
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
      '18': 'ユーザーテスト',
    };

    final taskData = generateTaskData(tree, tasks); //上記のデータを元にタスクデータを生成

    for (var entry in taskData.entries) {
      //タスクデータをFirestoreに保存
      final id = entry.key;
      final data = entry.value;
      await contentRef.doc('ID$id').set(data); //ID1, ID2, ID3...という名前で保存
    }

    // user_ID ドキュメントに tree と tasks のデータを保存
    await userRef.set({
      //user_IDドキュメントにtreeとtasksのデータを保存
      'tree': tree,
      'tasks': tasks
    }, SetOptions(merge: true));

    logger.info(tree);
    logger.info(tasks);
    logger.info("Registration Successful!");
  }

  Future<void> fetchUserData() async {
    //データを取得する関数

    final userRef = firestore.collection('users').doc('user_ID');

    // userドキュメントのデータを取得
    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      logger.warning("User data not found!");
      //return {};
    }

    logger.info("Fetched user data: ${snapshot.data()}");
    //return snapshot.data() as Map<String, dynamic>;
  }
}
