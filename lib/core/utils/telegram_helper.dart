import 'dart:async';
import 'dart:developer' as developer;
import 'dart:html' as html;
import 'dart:js_util' as js_util;

/// Возвращает объект пользователя из Telegram WebApp.
/// Если возникает ошибка или данные отсутствуют, выводит alert с сообщением об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    final telegram = js_util.getProperty(js_util.globalThis, 'Telegram');
    developer.log('telegram object: $telegram', name: 'telegram_helper');
    if (telegram == null) {
      html.window.alert(
          'Ошибка: не удалось получить объект Telegram. Проверьте, что приложение запущено внутри Telegram.');
      return null;
    }

    final webApp = js_util.getProperty(telegram, 'WebApp');
    developer.log('webApp object: $webApp', name: 'telegram_helper');
    if (webApp == null) {
      html.window
          .alert('Ошибка: не удалось получить объект WebApp из Telegram.');
      return null;
    }

    final initDataUnsafe = js_util.getProperty(webApp, 'initDataUnsafe');
    developer.log('initDataUnsafe: $initDataUnsafe', name: 'telegram_helper');
    if (initDataUnsafe == null) {
      html.window.alert(
          'Ошибка: не удалось получить initDataUnsafe из Telegram WebApp.');
      return null;
    }

    final user = js_util.getProperty(initDataUnsafe, 'user');
    developer.log('user object: $user', name: 'telegram_helper');
    if (user == null) {
      html.window.alert(
          'Ошибка: не удалось получить данные пользователя из Telegram WebApp.');
      return null;
    }

    final data = Map<String, dynamic>.from(user);
    developer.log('User data map: $data', name: 'telegram_helper');
    return data;
  } catch (e) {
    html.window.alert('Ошибка при получении данных Telegram: $e');
    developer.log('Exception in getTelegramUserData: $e',
        name: 'telegram_helper');
    return null;
  }
}

/// Возвращает Telegram ID пользователя в виде строки, если доступен.
/// В случае ошибки или отсутствия данных выводит alert.
Future<String?> getTelegramUserId() async {
  try {
    final userData = await getTelegramUserData();
    final id = userData?['id']?.toString();
    developer.log('Telegram User ID: $id', name: 'telegram_helper');
    if (id == null) {
      html.window.alert('Ошибка: Telegram User ID не получен.');
    }
    return id;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram User ID: $e');
    developer.log('Exception in getTelegramUserId: $e',
        name: 'telegram_helper');
    return null;
  }
}

/// Возвращает username пользователя Telegram, если доступен.
/// В случае ошибки или отсутствия данных выводит alert.
Future<String?> getTelegramUsername() async {
  try {
    final userData = await getTelegramUserData();
    final username = userData?['username'];
    developer.log('Telegram username: $username', name: 'telegram_helper');
    if (username == null) {
      html.window.alert('Ошибка: Telegram username не получен.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram username: $e');
    developer.log('Exception in getTelegramUsername: $e',
        name: 'telegram_helper');
    return null;
  }
}
