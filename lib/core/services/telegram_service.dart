import 'package:telegram_web_app/telegram_web_app.dart';

class TelegramService {
  final TelegramUser user;

  TelegramService() : user = TelegramWebApp.instance.initData.user;
}
