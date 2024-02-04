import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dennys_web_app/login/login_page.dart';
import 'package:dennys_web_app/global_setting/global_tree.dart';

class UserModelPage extends StatefulWidget {
  final User user;

  UserModelPage({required this.user});

  @override
  _UserModelPageState createState() => _UserModelPageState();
}

class _UserModelPageState extends State<UserModelPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  final Map<String, List<int>> tree = {/* tree data here */};
  final Map<String, String> tasks = {/* tasks data here */};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.user.photoURL != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.user.photoURL!),
              ),
            SizedBox(height: 10),
            Text('Name: ${widget.user.displayName ?? 'N/A'}'),
            Text('Email: ${widget.user.email ?? 'N/A'}'),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title here',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String title = _titleController.text;
                GlobalTree.initialize(title: title, tree: tree, tasks: tasks);
                var globalTree = GlobalTree.instance;
                await globalTree.addDataToFirestore(widget.user);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data added successfully!')),
                );
              },
              child: Text('Add Test Data to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}
