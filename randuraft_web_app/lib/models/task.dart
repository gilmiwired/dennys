class Task {
  final int id;
  final String task;
  final List<Task>? children;

  Task({required this.id, required this.task, this.children});

  factory Task.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['children'] as List?;
    List<Task> children = childrenFromJson
            ?.map((childJson) => Task.fromJson(childJson))
            .toList() ??
        [];
    return Task(
      id: json['id'],
      task: json['task'],
      children: children,
    );
  }
}
