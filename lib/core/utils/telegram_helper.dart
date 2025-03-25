import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

/// Получает данные пользователя из Telegram Mini Apps
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Инициализация WebApp (правильная обработка Promise) [[3]][[7]]
    if (js.context['Telegram']?['WebApp'] == null) {
      html.window.alert('Запустите приложение внутри Telegram!');
      return null;
    }

    await js_util.promiseToFuture(js_util
        .getProperty(js.context['Telegram']['WebApp'], 'ready')
        ?.call([]));

    // Получение и декодирование данных [[9]]
    String initDataUnsafe =
        js_util.getProperty(js.context['Telegram']['WebApp'], 'initDataUnsafe');

    if (initDataUnsafe.isEmpty) {
      html.window.alert('Ошибка: Данные не получены от Telegram');
      return null;
    }

    String decodedData = Uri.decodeComponent(initDataUnsafe);
    Map<String, dynamic> initData = jsonDecode(decodedData);
    return initData['user'];
  } catch (e) {
    html.window.alert('Ошибка получения данных: $e');
    return null;
  }
}

/// Получает Telegram User ID
Future<String?> getTelegramUserId() async {
  try {
    var user = await getTelegramUserData();
    return user?['id']?.toString();
  } catch (e) {
    html.window.alert('Ошибка получения ID: $e');
    return null;
  }
}

/// Получает Telegram username
Future<String?> getTelegramUsername() async {
  try {
    var user = await getTelegramUserData();
    return user?['username'];
  } catch (e) {
    html.window.alert('Ошибка получения username: $e');
    return null;
  }
}
