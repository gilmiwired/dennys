import 'package:flutter/material.dart';
import 'package:randuraft_web_app/api/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String message = "Loading...";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessageFromApi();
  }

  Future<void> fetchMessageFromApi() async {
    try {
      final fetchedMessage = await fetchMessage();
      setState(() {
        message = fetchedMessage;
      });
    } catch (e) {
      setState(() {
        message = "Failed to load message";
      });
    }
  }

  Future<void> sendMessage(String text) async {
    try {
      final responseMessage = await chat(text);
      setState(() {
        message = responseMessage;
      });
    } catch (e) {
      setState(() {
        message = "Failed to get chat response";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter to FastAPI'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
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
              onPressed: () {
                sendMessage(_controller.text);
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
