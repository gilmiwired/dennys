import 'package:flutter/material.dart';
import 'package:randuraft_web_app/api/api_service.dart';
import 'package:randuraft_web_app/models/task.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Task> tasks = [];
  final List<String> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessageFromApi();
    fetchTasksFromApi();
  }

  Future<void> fetchMessageFromApi() async {
    try {
      final fetchedMessage = await fetchMessage();
      setState(() {
        messages.add(fetchedMessage);
      });
    } catch (e) {
      setState(() {
        messages.add("Failed to load message");
      });
    }
  }

  Future<void> fetchTasksFromApi() async {
    try {
      final fetchedTasks = await fetchTasks();
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      setState(() {
        messages.add("Failed to load tasks");
      });
    }
  }

  Future<void> sendMessage(String text) async {
    try {
      final responseMessage = await chat(text);
      setState(() {
        messages.add(responseMessage);
      });
    } catch (e) {
      setState(() {
        messages.add("Failed to get chat response");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter to FastAPI'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...messages.map((msg) => Text(msg)),
            ListView.builder(
              shrinkWrap:
                  true, // makes the ListView only as big as its children
              physics:
                  const NeverScrollableScrollPhysics(), // since it's inside a SingleChildScrollView
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index].task),
                  subtitle: Text('ID: ${tasks[index].id}'),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your message',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => sendMessage(_controller.text),
              child: const Text('Send Message'),
            ),
            ElevatedButton(
              onPressed: fetchTasksFromApi,
              child: const Text('Fetch Tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
