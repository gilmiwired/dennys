import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dennys_web_app/logger/logger.dart';

class Node {
  final String title;
  final String parentID;
  final List<String> children;
  final String status;
  final String description;

  Node({
    required this.title,
    required this.parentID,
    required this.children,
    required this.status,
    required this.description,
  });

  void display() {
    logger.info('Title: $title');
    logger.info('ParentID: $parentID');
    logger.info('Children: $children');
    logger.info('Status: $status');
    logger.info('Description: $description');
  }

  @override
  String toString() {
    return 'Title: $title, ParentID:$parentID, Children: $children, Status: $status, Description: $description';
  }
}

class GlobalTree {
  static GlobalTree? _singleton;
  final String _key;
  final Map<String, List<int>> _tree;
  final Map<String, String> _tasks;
  final Map<String, Node> _nodeList = {};
  final Set<String> _collectedChildNodes = {};

  // Singletonのインスタンスを取得するためのgetter
  static GlobalTree get instance {
    if (_singleton == null) {
      throw Exception("GlobalTree is not initialized. Call initialize first.");
    }
    return _singleton!;
  }

  GlobalTree._internal({
    required String key,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
  })  : _key = key,
        _tree = tree,
        _tasks = tasks;

// 通常のコンストラクタ
  GlobalTree({
    required String key,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
  })  : _key = key,
        _tree = tree,
        _tasks = tasks {
    // NodeListを初期化
    for (var entry in tasks.entries) {
      List<String> children =
          tree[entry.key]?.map((e) => e.toString()).toList() ?? [];
      _nodeList[entry.key] = Node(
        title: entry.value,
        parentID: entry.key,
        children: children,
        status: "do",
        description: "説明",
      );
    }
  }

  static Future<GlobalTree> initializeAsync(String title) async {
    //aiの応答からtree,tasksを生成してGlobalTreeを初期化するメソッド
    if (_singleton != null) return _singleton!;

    Map<String, dynamic> result = await generateTaskTree(title);
    Map<String, List<int>> tree = result['tree'] as Map<String, List<int>>;
    Map<String, String> tasks = result['tasks'] as Map<String, String>;

    _singleton = GlobalTree._internal(key: title, tree: tree, tasks: tasks);

    // NodeListを初期化
    for (var entry in tasks.entries) {
      List<String> children =
          tree[entry.key]?.map((e) => e.toString()).toList() ?? [];
      _singleton!._nodeList[entry.key] = Node(
        title: entry.value,
        parentID: entry.key,
        children: children,
        status: "do",
        description: "説明",
      );
    }

    return _singleton!;
  }

  void collectAllChildNodes(String nodeKey) {
    _collectedChildNodes.clear();
    _gatherChildNodes(nodeKey);
  }

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

  // Getter methods
  Set<String> get collectedChildNodes => _collectedChildNodes;
  String get key => _key;
  Map<String, List<int>> get tree => _tree;
  Map<String, String> get tasks => _tasks;
  Map<String, Node> get nodeList => _nodeList;

  //ノードを追加するメソッド
  void addNode(String title, String parentID,
      {bool insertAschild = false, List<String>? newChildren}) {
    Node parentNode = _nodeList[parentID]!; //親ノードの情報を取得(親ノードのchildrenを更新するため)

    //tasksの最後尾のキーにインクリメントして新しいIDを生成
    int newIDNum = int.parse(_tasks.keys.last) + 1;
    String newID = newIDNum.toString();

    // 新しいノードの作成
    List<String> childrenForNewNode = newChildren ?? [];
    Node newNode = Node(
        title: title,
        parentID: parentID,
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
    _nodeList[parentID] = Node(
      //親ノードの更新
      title: parentNode.title,
      parentID: parentNode.parentID,
      children: updatedChildren, //先ほど更新した子ノードのリストをセット
      status: parentNode.status,
      description: parentNode.description,
    );
    //新しいノードの子ノードのparentIDを更新
    if (newChildren != null) {
      for (String child in newChildren) {
        _nodeList[child] = Node(
          title: _nodeList[child]!.title,
          parentID: newID,
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
