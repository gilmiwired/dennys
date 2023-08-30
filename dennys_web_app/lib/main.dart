import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dennys_web_app/login/login_page.dart';
import 'package:dennys_web_app/register/registration_page.dart';
import 'package:dennys_web_app/profile/user_data.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dennys_web_app/game/test_game.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Node Addition Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Removed empty class body
  @override
  void initState() {
    super.initState();
    // Initialization code here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Save Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Check login state
                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser == null) {
                  // Navigate to login page if not logged in
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  // Navigate to UserModelPage if logged in
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => UserModelPage(user: currentUser)),
                  );
                }
              },
              child: const Text('Auth State'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to registration page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BuildGame()),
                );
              },
              child: const Text('Game'),
            ),
          ],
        ),
      ),
    );
  }
}
