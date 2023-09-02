import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dennys_web_app/logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dennys_web_app/login/login_page.dart';
import 'dart:math';

class Node {
  final String title;
  final String parent;
  final List<String> children;
  final String status;
  final String description;
  int x = 0;
  int y = 0;

  Node({
    required this.title,
    required this.parent,
    required this.children,
    required this.status,
    required this.description,
  });

  void display() {
    logger.info('Title: $title');
    logger.info('Parent: $parent');
    logger.info('Children: $children');
    logger.info('Status: $status');
    logger.info('Description: $description');
  }

  @override
  String toString() {
    return 'Title: $title, Parent:$parent, Children: $children, Status: $status, Description: $description';
  }
}

class Edge {
  final String parent;
  final String child;

  Edge({required this.parent, required this.child});

  @override
  String toString() {
    return 'Parent: $parent, Child: $child';
  }
}


  // プライベートコンストラクタ
  GlobalTree._internal({
    required String title,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
  })  : _title = title,
        _tree = tree,
        _tasks = tasks;

  static void initialize({
    required String title,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
    bool isAsync = false,
  }) {
    if (_singleton != null) return;

    if (isAsync) {
      // 非同期の初期化ロジック
      _initializeAsync(title).then((result) {
        _singleton = GlobalTree._internal(
          title: title,
          tree: result['tree'],
          tasks: result['tasks'],
        );
        _populateNodeListAndEdges();
      });
    } else {
      // 同期の初期化ロジック
      _singleton = GlobalTree._internal(
        title: title,
        tree: tree,
        tasks: tasks,
      );
      _populateNodeListAndEdges();
    }
  }

  static Future<Map<String, dynamic>> _initializeAsync(String title) async {
    Map<String, dynamic> result = await generateTaskTree(title);
    return result;
  }

  static void _populateNodeListAndEdges() {
    // NodeListとEdgeを初期化
    for (var entry in _singleton!._tasks.entries) {
      List<String> children =
          _singleton!._tree[entry.key]?.map((e) => e.toString()).toList() ?? [];
      _singleton!._nodeList[entry.key] = Node(
        title: entry.value,
        parent: entry.key,
        children: children,
        status: "do",
        description: "説明",
      );

      // Edgeを初期化
      for (var child in children) {
        _singleton!._edges.add(Edge(parent: entry.key, child: child));
      }
    }
  }

// Getter methods
  Set<String> get collectedChildNodes => _collectedChildNodes;
  String get title => _title;
  Map<String, List<int>> get tree => _tree;
  Map<String, String> get tasks => _tasks;
  Map<String, Node> get nodeList => _nodeList;
  List<Edge> get edges => _edges;

  //ノードを追加するメソッド
  void addNode(String title, String parent, {bool insertAschild = false, List<String>? newChildren}) {
    Node parentNode = _nodeList[parent]!; //親ノードの情報を取得(親ノードのchildrenを更新するため)

    //tasksの最後尾のキーにインクリメントして新しいIDを生成
    int newIDNum = int.parse(_tasks.keys.last) + 1;
    String newID = newIDNum.toString();

    // 新しいノードの作成
    List<String> childrenForNewNode = newChildren ?? [];
    Node newNode = Node(
        title: title,
        parent: parent,
        children: childrenForNewNode, //親ノードの子ノードを子として持つ
        status: "do",
        description: "説明");

    // tasksを更新
    _tasks[newID] = title;

    // nodeListの更新

    //親ノードの子ノードのリストを取得
    List<String> updatedChildren =
        List.from(parentNode.children); //親ノードの子リストのコピーを作成
    if (newChildren != null) {
      for (String child in newChildren) {
        updatedChildren.remove(child); //親ノードの子ノードのリストから新しいノードの子ノードを削除
      }
    }

    updatedChildren.insert(0, newID); //親の子リストに新しいノードを追加

    _nodeList[newID] = newNode; // nodeListに新しいノードを追加
    _nodeList[parent] = Node(
      //親ノードの更新
      title: parentNode.title,
      parent: parentNode.parent,
      children: updatedChildren, //先ほど更新した子ノードのリストをセット
      status: parentNode.status,
      description: parentNode.description,
    );
    //新しいノードの子ノードのparentを更新
    if (newChildren != null) {
      for (String child in newChildren) {
        _nodeList[child] = Node(
          title: _nodeList[child]!.title,
          parent: newID,
          children: _nodeList[child]!.children,
          status: _nodeList[child]!.status,
          description: _nodeList[child]!.description,
        );
      }
    }
  }

  static Map<String, dynamic> extractTaskTree(String aiResponse) {
    //応答をtree,tasksに整理
    String validJsonString =
        aiResponse.replaceAll("'", '"'); //正規表現によるシングルクォートをダブルクォートに変換
    final RegExp pattern = RegExp(r"(\{.*\})");
    final Match? match = pattern.firstMatch(validJsonString);

    if (match != null) {
      String extracted = match.group(1)!;
      Map<String, dynamic> decoded = json.decode(extracted);

      // treeをMap<String, List<int>>に変換
      Map<String, List<int>> tree = {};
      (decoded['tree'] as Map<String, dynamic>).forEach((key, value) {
        tree[key] = (value as List).map((e) => int.parse(e)).toList();
      });

      // tasksをMap<String, String>に変換
      Map<String, String> tasks = Map<String, String>.from(decoded['tasks']);

      return {
        'tree': tree,
        'tasks': tasks,
      };
    } else {
      print("Error: Failed to extract the task tree from the AI response.");
      return {};
    }
  }

  static Future<Map<String, dynamic>> generateTaskTree(String userGoal) async {
    //userGoalに対するAIの応答を返す。（今のところは固定でtree,tasks生成のみ。そのうちフィードバックとかできるようにする。）
    await dotenv.load(fileName: '.env');
    OpenAI.apiKey = dotenv.get('OPEN_AI_API_KEY');

    final messages = [
      OpenAIChatCompletionChoiceMessageModel(
        content:
            "You are a task planner. The 'tree' represents the hierarchical structure of tasks where each key is a task ID and its corresponding value is a list of subtask IDs. The 'tasks' provides detailed descriptions for each task ID. Based on the user's goal, generate a task tree with both 'tree' and 'tasks'. If possible, generate at least 10 tasks, making sure that the tasks are MECE and that the level below the tree provides specific actions to guide the user toward the goal.The response should be structured as follows: {'tree': {'1': ['2', '3',...], '2': ['4', '5',...], '3': [],...}, 'tasks': {'1': 'Goal description', '2': 'Subtask 1 description',...}}. Ensure that the information is provided in a single line without any line breaks.Response in japanese. Exclude all other explanations.",
        role: OpenAIChatMessageRole.system,
      ),
      OpenAIChatCompletionChoiceMessageModel(
        content: userGoal,
        role: OpenAIChatMessageRole.user,
      ),
    ];

    int retryCount = 0;
    const int maxRetries = 5;
    Map<String, dynamic> result = {};

    while (retryCount < maxRetries) {
      try {
        final response = await OpenAI.instance.chat.create(
          model: 'gpt-3.5-turbo',
          messages: messages,
        );

        final aiResponse = response.choices.first.message.content;
        result = extractTaskTree(aiResponse);

        if (result.containsKey('tree') && result.containsKey('tasks')) {
          break;
        }
      } catch (error) {
        print("Error occurred: $error");
      }

      retryCount++;
    }

    if (retryCount == maxRetries) {
      print("Maximum retries reached without a valid response.");
    }

    return result;
  }

  // シングルトンのインスタンスをリセットするメソッド
  static void resetInstance() {
    _singleton = null;
  }

  //指定ノードの子ノードセット作成(非表示セット)
  void collectAllChildNodes(String nodeKey) {
    _collectedChildNodes.clear();
    _gatherChildNodes(nodeKey);
  }

  //子ノード収集
  void _gatherChildNodes(String nodeId) {
    _collectedChildNodes.add(nodeId);
    if (_tree.containsKey(nodeId)) {
      for (int child in _tree[nodeId]!) {
        _collectedChildNodes.add(child.toString());
        print('Collected Node: $child');
        _gatherChildNodes(child.toString());
      }
    }
  }

  // DFSを用いてノードのレイアウトを計算する
  int dfsLayout(Node node, int x, int startY, Map<String, int> childCounts, int level) {
    int nextY = startY;

    // このノードのx座標を設定
    node.x = maxWidth - (level * (nodeWidth + horizontalGap));

    List<int> childHeights = [];

    // 子ノードのレイアウトを計算
    for (String childID in node.children) {
      Node? child = _nodeList[childID];
      if (child != null) {
        int childHeight = dfsLayout(child, x, nextY, childCounts, level + 1);
        childHeights.add(child.y);
        nextY = childHeight;
      }
    }

    // このノードのy座標を子ノード群の中央に設定
    if (childHeights.isNotEmpty) {
      int minY = childHeights.reduce(min);
      int maxY = childHeights.reduce(max);
      node.y = (minY + maxY) ~/ 2;
    } else {
      node.y = startY;
    }

    // 最大高さを更新
    maxHeight = max(maxHeight, node.y + nodeHeight);

    return nextY + nodeHeight + verticalGap;
  }

  // レイアウト計算のエントリーポイント
  /*
  void calculateLayout() {
    // 最大幅を計算
    maxWidth = calculateMaxWidth();

    // 初期化
    maxHeight = 0;

    // 子ノードの数を事前計算
    Map<String, int> childCounts = {};
    countChildren("1", childCounts);

    // レイアウト計算
    Node? root = _nodeList["1"];
    if (root != null) {
      dfsLayout(root, 0, 0, childCounts, 0);
    }
  }
  */
  // 最大幅を計算する
  int calculateMaxWidth() {
    int maxDepth = findMaxDepth("1", 0);
    return (maxDepth + 1) * (nodeWidth + horizontalGap);
  }

  // 最大深度を計算する
  int findMaxDepth(String nodeId, int currentDepth) {
    int maxDepth = currentDepth;
    for (String childId in _nodeList[nodeId]?.children ?? []) {
      maxDepth = max(maxDepth, findMaxDepth(childId, currentDepth + 1));
    }
    return maxDepth;
  }

  // 各ノードの子ノード（およびその子孫）の数を計算する
  int countChildren(String nodeId, Map<String, int> childCounts) {
    int count = 0;
    for (String childID in _nodeList[nodeId]?.children ?? []) {
      count += 1 + countChildren(childID, childCounts);
    }
    childCounts[nodeId] = count;
    return count;
  }


  //エッジ
  void addEdge(String parent, String child) {
    _edges.add(Edge(parent: parent, child: child));
  }

  void removeEdge(String parent, String child) {
    _edges.removeWhere((edge) => edge.parent == parent && edge.child == child);
  }

  // 2Dマップへのマッピングを行うメソッド
  void mapTo2D() {
    // ルートノード（仮にIDが"1"とする）の位置をマップの中心に設定
    Node rootNode = _nodeList["1"]!;
    rootNode.x = maxWidth ~/ 2;
    rootNode.y = maxHeight ~/ 2;

    // ルートノードから始めて、再帰的に子ノードの位置を設定
    _setPosition(rootNode, rootNode.x, rootNode.y);
  }

  // ノードとその子ノードの位置を再帰的に設定するプライベートメソッド
  void _setPosition(Node node, int x, int y) {
    node.x = x;
    node.y = y;

    List<String> children = node.children;
    int numChildren = children.length;

    // 子ノードがなければ終了
    if (numChildren == 0) return;

    // 子ノードの位置を設定（円形に配置）
    double angleStep = 2 * pi / numChildren;
    for (int i = 0; i < numChildren; i++) {
      double angle = i * angleStep;
      int childX = x + (cos(angle) * horizontalGap).toInt();
      int childY = y + (sin(angle) * verticalGap).toInt();
      _setPosition(_nodeList[children[i]]!, childX, childY);
    }
  }

  // マップの範囲を定義
  int mapWidth = 1000;
  int mapHeight = 1000;

// ルートノードの座標を設定
  void setRootNode() {
    Node rootNode = _nodeList['1']!;
    rootNode.x = mapWidth;  // 右端
    rootNode.y = mapHeight ~/ 2;// 中央
  }
  Future<void> addDataToFirestore(User user) async {
    try {
      // タイトルが既に存在するか確認
      QuerySnapshot snapshot = await _firestore.collection('users').doc(user.uid).collection('titles')
          .where('title', isEqualTo: title)
          .get();

      // タイトルが存在しない場合のみ追加
      if (snapshot.docs.isEmpty) {
        // タイトル用の新しいドキュメントを作成
        DocumentReference titleRef = _firestore.collection('users').doc(user.uid).collection(title).doc('info');

        await titleRef.set({
          'title': title,
        });

        // そのドキュメント内にtasksとtreeサブコレクションを追加
        await _firestore.collection('users').doc(user.uid).collection(title).doc('tasks').set({
          'data': tasks,
        });

        await _firestore.collection('users').doc(user.uid).collection(title).doc('tree').set({
          'data': tree,
        });

      } else {
        print('Title already exists.');
      }
    } catch (e) {
      print(e);
    }
  }





// レイアウト計算のエントリーポイント
  void calculateLayout() {
    // ルートノードの座標を設定
    setRootNode();

    // ルートノードから始めて、再帰的に子ノードの位置を設定
    Node rootNode = _nodeList['1']!;
    //assignCoordinates(rootNode, 0, 100);  // angleOffsetとdistanceStepは任意の値
  }



  //コンソールにノード表示
  void printNodeList() {
    print('--- Print Node List ---');

    print('--- Tree ---');
    for (var entry in _tree.entries) {
      if (!_collectedChildNodes.contains(entry.key)) {
        print('Key: ${entry.key}, Value: ${entry.value.join(', ')}');
      }
    }

    print('--- Tasks ---');
    for (var entry in _tasks.entries) {
      if (!_collectedChildNodes.contains(entry.key)) {
        print('Key: ${entry.key}, Value: ${entry.value}');
      }
    }

    print('--- NodeList ---');
    for (var entry in _nodeList.entries) {
      if (!_collectedChildNodes.contains(entry.key)) {
        print('Key: ${entry.key}, Value: ${entry.value.toString()}');
      }
    }

    print('--- CollectedChildNodes ---');
    print(_collectedChildNodes.join(', '));
  }
}
