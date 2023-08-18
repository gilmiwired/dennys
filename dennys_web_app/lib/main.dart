import 'package:dennys_web_app/Manual/Manual_Registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(App());
}

class App extends StatelessWidget {
    final ManualResist dataService = ManualResist();
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(title: const Text('Firestore Save Data')),
                body: Center(
                    child: ElevatedButton(
                        onPressed: () => dataService.fetchUserData(),
                        child: const Text('Save Data to Firestore'),
                    ),
                ),
            ),
        );
    }
}
