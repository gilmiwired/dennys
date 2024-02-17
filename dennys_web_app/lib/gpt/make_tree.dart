import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.env['OPEN_AI_API_KEY']!;
  OpenAI.showLogs = true;
  OpenAI.showResponsesLogs = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task Tree Generator'),
        ),
        body: const ChatWidget(),
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your main task',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final userGoal = _controller.text;
              generateTaskTree(userGoal);
            },
            child: const Text('Generate Task Tree'),
          ),
        ],
      ),
    );
  }

  void generateTaskTree(String userGoal) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${dotenv.env['OPEN_AI_API_KEY']!}',
    };
    final body = json.encode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {
          "role": "user",
          "content":
              "Given a large task: $userGoal, decompose it into a hierarchical task structure."
        },
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final String responseText =
            responseBody['choices'][0]['message']['content'].trim();
        if (mounted) {
          showResponseDialog(responseText);
        }
      } else {
        if (mounted) {
          showResponseDialog(
              "Failed to generate a response. Please try again.");
        }
      }
    } catch (e) {
      debugPrint('Error generating task tree: $e');
      if (mounted) {
        showResponseDialog("Error generating task tree: $e");
      }
    }
  }

  void showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Task Tree"),
          content: SingleChildScrollView(
            child: Text(response),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
