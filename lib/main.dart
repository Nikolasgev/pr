import 'package:flutter/material.dart';

// import 'core/firebase/firebase_config.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseConfig.initializeFirebase();
  setupInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture App',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
