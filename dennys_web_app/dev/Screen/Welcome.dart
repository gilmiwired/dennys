//SignupまたはSignin後に入れるやつ
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget {
  final User? user;

  WelcomeScreen({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.displayName ?? user?.email}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('You have successfully signed in.'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to another part of the app or sign out, etc.
              },
              child: Text('Proceed to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
