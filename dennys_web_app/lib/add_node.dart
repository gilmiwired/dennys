class TaskManager {
  // フィールド
  Map<String, List<int>> tree = {};
  Map<String, String> tasks = {};
  List<String> idList = [];

  // ノードの追加メソッド
  void addNode(String id, String task, [List<int>? children]) {
    if (!tree.containsKey(id) && !tasks.containsKey(id)) {
      tree[id] = children ?? [];
      tasks[id] = task;
      idList.add(id);
    } else {
      print("The node with ID: $id already exists.");
    }
  }

  // デバッグ用の表示メソッド
  void display() {
    print("Tree: $tree");
    print("Tasks: $tasks");
    print("ID List: $idList");
  }
}

void main() {
  var manager = TaskManager();

  manager.addNode('1', 'ゲームを作る', [2, 3, 4]);
  manager.addNode('2', 'デザイン');
  manager.addNode('3', 'プログラム');

  manager.display();

  manager.removeNode('2');

  manager.display();
}
