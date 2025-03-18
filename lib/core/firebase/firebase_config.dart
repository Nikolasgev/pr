import 'package:firebase_core/firebase_core.dart';
import 'package:per_shop/firebase_options.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
