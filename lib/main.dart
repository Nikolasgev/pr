import 'package:flutter/material.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

import 'core/firebase/firebase_config.dart';
import 'core/router/app_router.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  setupInjection();
  if (TelegramWebApp.instance.isSupported) {
    TelegramWebApp.instance.ready();
    Future.delayed(
        const Duration(milliseconds: 500),
        () => {
              TelegramWebApp.instance.expand,
              TelegramWebApp.instance.disableVerticalSwipes(),
            });
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Periche Telegram Shop',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _appRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}
