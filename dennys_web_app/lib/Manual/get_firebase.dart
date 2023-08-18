import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dennys_web_app/logger/logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class get_firebase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> saveToe() async {
    CollectionReference collection = firestore.collection('users');

    // 単一のドキュメントを取得する場合
    var document = await collection.doc('user').get();
    logger.info(document.data());

    // コレクション内のすべてのドキュメントを取得する場合
    var documents = await collection.get();
    for (var doc in documents.docs) {
      logger.info(doc.data());
    }
  }
}
