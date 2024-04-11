Map<int, Map<String, dynamic>> generateTaskData(
    Map<String, List<int>> tree, Map<String, String> tasks) {
  final taskData = <int, Map<String, dynamic>>{};

  Map<String, dynamic> generateTaskRecursive(String taskId) {
    final childrenIds = tree[taskId] ?? [];

    taskData[int.parse(taskId)] = {
      "title": tasks[taskId],
      "children": childrenIds,
      "status": "done",
      "description": "説明"
    };

    for (var childId in childrenIds) {
      generateTaskRecursive(childId.toString());
    }

    return taskData[int.parse(taskId)]!;
  }

  final parentIds = tree.keys.toSet();
  final childIds =
      tree.values.expand((item) => item).map((e) => e.toString()).toSet();
  final rootIds = parentIds.difference(childIds);

  for (var rootId in rootIds) {
    generateTaskRecursive(rootId);
  }

  return taskData;
}
