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
        parentID: entry.key,
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
  void addNode(String title, String parentID,
      {bool insertAschild = false, List<String>? newChildren}) {
    Node parentNode = _nodeList[parentID]!; //親ノードの情報を取得(親ノードのchildrenを更新するため)

    //tasksの最後尾のキーにインクリメントして新しいIDを生成
    int newIDNum = int.parse(_tasks.keys.last) + 1;
    String newID = newIDNum.toString();

    // 新しいノードの作成
    Node newNode = Node(
        title: title,
        parentID: parentID,
        children: parentNode.children.isEmpty
            ? []
            : parentNode.children, //親ノードの子ノードを子として持つ
        status: "do",
        description: "説明");

    // tasksを更新
    _tasks[newID] = title;

    // nodeListの更新

    //親ノードの子ノードのリストを取得
    List<String> updatedChildren =
        List.from(parentNode.children); //親ノードの子リストのコピーを作成
    if (insertAschild) {
      //割り込み
      updatedChildren = [newID];
    } else {
      updatedChildren.insert(0, newID); //親の子リストに新しいノードを追加
    }

    _nodeList[newID] = newNode; // nodeListに新しいノードを追加
    _nodeList[parentID] = Node(
      //親ノードの更新
      //親ノードの子ノードのリストを更新
      title: parentNode.title,
      parentID: parentNode.parentID,
      children: updatedChildren, //先ほど更新した子ノードのリストをセット
      status: parentNode.status,
      description: parentNode.description,
    );
    //新しいノードの子ノードのparentIDを更新
    if (newChildren != null) {
      //新しいノードの子ノードがある場合
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
