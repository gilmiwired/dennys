import 'global_tree.dart';

void main() async {
  // userGoalに基づいてタスクツリーを生成
  String userGoal = "英語を話せるようになる";  // こちらの文字列を目的に応じて変更してください
  await GlobalTree.initializeAsync(userGoal);

  // タスクツリーの表示
  GlobalTree.instance.printNodeList();
}
