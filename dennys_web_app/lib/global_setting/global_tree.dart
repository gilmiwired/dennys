import 'package:dennys_web_app/logger/logger.dart';

class Node {
  final String title;
  final List<String> children;
  final String status;
  final String description;

  Node({
    required this.title,
    required this.children,
    required this.status,
    required this.description,
  });

  void display() {
    logger.info('Title: $title');
    logger.info('Children: $children');
    logger.info('Status: $status');
    logger.info('Description: $description');
  }

  @override
  String toString() {
    return 'Title: $title, Children: $children, Status: $status, Description: $description';
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

  static void initialize({
    required String key,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
  }) {
    if (_singleton != null) return;

    _singleton = GlobalTree._internal(key: key, tree: tree, tasks: tasks);

    // NodeListを初期化
    for (var entry in tasks.entries) {
      List<String> children =
          tree[entry.key]?.map((e) => e.toString()).toList() ?? [];
      _singleton!._nodeList[entry.key] = Node(
        title: entry.value,
        children: children,
        status: "do",
        description: "説明",
      );
    }
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
  void addNode(String title, String parentID, {bool insertAschild = false}) {
    //割り込みをする場合はtrueで呼び出す
    Node parentNode = _nodeList[
        parentID]!; //!を外すとvalue of type 'Node?' can't be assigned to a variable of type 'Node'.ってなる
    String newID = 'NewID'; //新しいノードの取得は保留
    int newIDNum = 1; //treeで使う新しいIDの数字
    // 新しいノードの作成
    Node newNode = Node(
        title: title,
        children:
            parentNode.children.isEmpty ? [] : [parentNode.children.first],
        status: "do",
        description: "説明");

    // nodeListに新しいノードを追加
    _nodeList[newID] = newNode;

    // tasksを更新
    _tasks[newID] = title;

    // treeを更新
    if (parentNode.children.isEmpty) {
      // 親ノードが子ノードを持っていない場合の処理
      _tree[parentID] = [newIDNum];
    } else if (insertAschild) {
      // 新しいノードを親ノードの子ノードリストに追加する場合の処理(デフォルト)
      parentNode.children.insert(0, newID);
    } else {
      // 新しいノードが元々の子ノードたちを子として持つ場合の処理(割り込み)
      List<String> originalChildren = List.from(parentNode.children);
      _tree[parentID] = [newIDNum];
      _tree[newID] = originalChildren.map((e) => int.parse(e)).toList();
      newNode.children.addAll(originalChildren);
    }
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
