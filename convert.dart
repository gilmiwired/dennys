import 'dart:collection';

Map<int, Map<String, dynamic>> generateTaskData(
    //タスクデータを生成する関数
    List<List<dynamic>> tree,
    Map<int, String> tasks) {
  //ツリー構造とタスク名のマップを受け取る
  final taskData = <int, Map<String, dynamic>>{}; //タスクデータを格納するマップ

  Map<String, dynamic> generateTaskRecursive(int taskId) {
    //再帰的にタスクデータを生成する関数
    //再帰的にタスクデータを生成する関数
    final childrenIds = tree //子タスクのIDを取得
        .where((item) => item[0] == taskId) //親タスクのIDが一致するものをフィルタリング
        .expand((item) => item[1]) //子タスクのIDを展開イテレータブルに展開
        .toList(); //なぜリストに変換するのかというと、後でchildrenの長さを取得するため

    taskData[taskId] = {
      //タスクデータを格納
      "title": tasks[taskId],
      "children": childrenIds,
      "status": "do",
      "description": "説明" //ここは後で何とかする。
    };

    for (var childId in childrenIds) {
      //取得した子タスクのIDを再帰的に処理してそれらのタスクデータを取得
      generateTaskRecursive(childId);
    }

    return taskData[taskId]!; //タスクデータを返す
  }

  final parentIds = tree.map((item) => item[0]).toSet(); //入力されたtreeから親タスクのIDを取得
  final childIds =
      tree.expand((item) => item[1]).toSet(); //入力されたtreeから子タスクのIDを取得
  final rootIds =
      parentIds.difference(childIds); //親タスクのIDから子タスクのIDを除いたものがルートタスクのID

  for (var rootId in rootIds) {
    //ルートタスクのIDを再帰的に処理してタスクデータを取得
    generateTaskRecursive(rootId);
  }

  return taskData;
}

void main() {
  final sampleTree = [
    [
      1,
      [2, 3, 4, 5, 6]
    ],
    [
      2,
      [7, 8, 9]
    ],
    [
      3,
      [10, 11, 12]
    ],
    [
      4,
      [13, 14]
    ],
    [
      5,
      [15, 16]
    ],
    [
      6,
      [17, 18]
    ]
  ];

  final sampleTasks = {
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

  final generatedData = generateTaskData(sampleTree, sampleTasks);
  print(generatedData);
}
