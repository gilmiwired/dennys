import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// extractTaskTree関数
// extractTaskTree関数
Map<String, dynamic> extractTaskTree(String aiResponse) {
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

Future<Map<String, dynamic>> generateTaskTree(String userGoal) async {
  //userGoalに対するAIの応答を返す。（今のところは固定でtree,tasks生成のみ。そのうちフィードバックとかできるようにする。）
  await dotenv.load(fileName: '.env.example');
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

  final response = await OpenAI.instance.chat.create(
    model: 'gpt-3.5-turbo',
    messages: messages,
  );

  final aiResponse = response.choices.first.message.content;
  return extractTaskTree(aiResponse); //応答をtree,tasksに整理して返す
}
