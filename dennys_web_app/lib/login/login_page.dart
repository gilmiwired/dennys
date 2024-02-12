import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dennys_web_app/profile/user_model.dart';
import 'package:dennys_web_app/register/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint("Attempting to login with email: ${_emailController.text}");
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        debugPrint("Login successful for email: ${_emailController.text}");
        UserModel userModel = UserModel(
            uid: userCredential.user!.uid, email: userCredential.user!.email);

        debugPrint("UserModel: uid=${userModel.uid}, email=${userModel.email}");
        final localContext = context;
        if (mounted) {
          ScaffoldMessenger.of(localContext).showSnackBar(
            const SnackBar(
                content: Text('Successfully Logged In!')), // Add const here
          );
        }
      } catch (e) {
        debugPrint("Login failed with error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login Failed: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'), // Add const here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Already const
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Email'), // Add const here
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Already const
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password'), // Add const here
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16), // Already const
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'), // Add const here
              ),
              const SizedBox(height: 16), // Already const
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RegistrationPage())); // Add const here
                },
                child: const Text('アカウントがない場合はこちら'), // Add const here
              ),
            ],
          ),
        ),
      ),
    );
  }
}
