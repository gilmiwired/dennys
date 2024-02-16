import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY')
  static const apiKey = _Env.apiKey;
}

Future<void> main() async {
  OpenAI.apiKey = Env.apiKey;
  OpenAI.showLogs = true;
  OpenAI.showResponsesLogs = true;
  List<OpenAIModelModel> models = await OpenAI.instance.model.list();
  OpenAIModelModel firstModel = models.first;

  print(firstModel.id); // ...
  print(firstModel.permission); // ..
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Task Tree Generator'),
        ),
        body: ChatWidget(),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your main task',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final userGoal = _controller.text;
              generateTaskTree(userGoal, context);
            },
            child: Text('Generate Task Tree'),
          ),
        ],
      ),
    );
  }

  void generateTaskTree(String userGoal, BuildContext context) async {
    final prompt =
        "Given a large task: $userGoal, decompose it into a hierarchical task structure.";

    try {
      final completion = await OpenAI.instance.completion.create(
        model: "gpt-3.5-turbo-1106",
        prompt: prompt, // ユーザーからの入力をプロンプトとして使用
        n: 1,
        stop: ["\n"],
        echo: true,
        seed: 42,
        bestOf: 2, // 創造性の度合いを指定
      );

      final response = completion.choices.first.text.trim();

      // Use a method to show the dialog that doesn't rely on BuildContext across async gaps
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Task Tree"),
                content: SingleChildScrollView(
                  child: Text(response),
                ),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      print('Error generating task tree: $e');
    }
  }
}
