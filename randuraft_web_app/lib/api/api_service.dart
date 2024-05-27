import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:randuraft_web_app/models/task.dart';

const String baseUrl = 'http://127.0.0.1:8000';

Future<String> fetchMessage() async {
  final response = await http.get(Uri.parse('$baseUrl/'));
  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
  } else {
    throw Exception('Failed to load message');
  }
}

Future<Map<String, dynamic>> createItem(String name, String description) async {
  final response = await http.post(
    Uri.parse('$baseUrl/items/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'name': name, 'description': description}),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to create item');
  }
}

Future<String> chat(String message) async {
  final response = await http.post(
    Uri.parse('$baseUrl/chat'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'message': message}),
  );

  if (response.statusCode == 200) {
    var decoded = json.decode(utf8.decode(response.bodyBytes));
    return decoded['response_message'];
  } else {
    throw Exception('Failed to get chat response');
  }
}

Future<List<Task>> fetchTasks() async {
  final response = await http.post(Uri.parse('$baseUrl/test/task'),
      headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    List<dynamic> tasksJson = json.decode(utf8.decode(response.bodyBytes));
    return tasksJson.map((taskJson) => Task.fromJson(taskJson)).toList();
  } else {
    throw Exception('Failed to load tasks');
  }
}
