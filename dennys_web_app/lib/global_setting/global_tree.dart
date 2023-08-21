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
      List<String> children = tree[entry.key]?.map((e) => e.toString()).toList() ?? [];
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
