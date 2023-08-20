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

}


class GlobalTree {
  static GlobalTree? _singleton;
  final String _key;
  final Map<String, List<int>> _tree;
  final Map<String, String> _tasks;
  final Map<String, Node> _nodeList = {};

  factory GlobalTree({
    required String key,
    required Map<String, List<int>> tree,
    required Map<String, String> tasks,
    required Map<String, Node> nodeList,
  }) {
    if (_singleton == null) {
      _singleton = GlobalTree._internal(key: key, tree: tree, tasks: tasks);

      // NodeListを初期化
      for (var entry in tasks.entries) {
        _singleton!._nodeList[entry.key] = Node(
          title: entry.value,
          children: tree[entry.key]!.map((e) => e.toString()).toList(),
          status: "do",
          description: "説明",
        );
      }
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

  // Getter methods if needed
  String get key => _key;
  Map<String, List<int>> get tree => _tree;
  Map<String, String> get tasks => _tasks;
  Map<String, Node> get nodeList => _nodeList;

  // このメソッドを介してシングルトンのインスタンスをリセット
  static void resetInstance() {
    _singleton = null;
  }
  void printNodeList() {
    _nodeList.forEach((key, node) {
      logger.info('Key: $key, Node: $node');
    });
  }
}
