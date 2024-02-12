//SignupまたはSignin後に入れるやつ
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatelessWidget {
  final User? user;

  const WelcomeScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user?.displayName ?? user?.email}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('You have successfully signed in.'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to another part of the app or sign out, etc.
              },
              child: const Text('Proceed to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
