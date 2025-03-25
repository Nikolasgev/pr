import 'dart:async';
import 'dart:developer' as developer;
import 'dart:js_util' as js_util;

/// Возвращает объект пользователя из Telegram WebApp после задержки.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  final telegram = js_util.getProperty(js_util.globalThis, 'Telegram');
  developer.log('telegram object: $telegram', name: 'telegram_helper');
  if (telegram == null) return null;

  final webApp = js_util.getProperty(telegram, 'WebApp');
  developer.log('webApp object: $webApp', name: 'telegram_helper');
  if (webApp == null) return null;

  final initDataUnsafe = js_util.getProperty(webApp, 'initDataUnsafe');
  developer.log('initDataUnsafe: $initDataUnsafe', name: 'telegram_helper');
  if (initDataUnsafe == null) return null;

  final user = js_util.getProperty(initDataUnsafe, 'user');
  developer.log('user object: $user', name: 'telegram_helper');
  if (user == null) return null;

  final data = Map<String, dynamic>.from(user);
  developer.log('User data map: $data', name: 'telegram_helper');
  return data;
}

/// Возвращает Telegram ID пользователя в виде строки, если доступен.
Future<String?> getTelegramUserId() async {
  final userData = await getTelegramUserData();
  final id = userData?['id']?.toString();
  developer.log('Telegram User ID: $id', name: 'telegram_helper');
  return id;
}

/// Возвращает username пользователя Telegram, если доступен.
Future<String?> getTelegramUsername() async {
  final userData = await getTelegramUserData();
  final username = userData?['username'];
  developer.log('Telegram username: $username', name: 'telegram_helper');
  return username;
}
