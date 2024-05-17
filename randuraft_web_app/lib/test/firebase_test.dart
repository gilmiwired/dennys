import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
        authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
        projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
        storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
        messagingSenderId:
            String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
        appId: String.fromEnvironment('FIREBASE_APP_ID'),
        measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      ),
    );
  });

  test('Firebase Auth Sign in and Sign out', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: 'test@example.com', password: 'testpassword');
    expect(userCredential.user, isNotNull);

    // Sign out
    await auth.signOut();
    expect(auth.currentUser, isNull);
  });
}
