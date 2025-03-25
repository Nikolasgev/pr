import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

/// Асинхронно получает данные пользователя из Telegram WebApp.
/// Если данные не получены, выводит alert с сообщением об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Проверяем, что объект Telegram доступен
    var telegram = js.context['Telegram'];
    if (telegram == null) {
      html.window.alert('Запустите приложение внутри Telegram!');
      return null;
    }

    var webApp = telegram['WebApp'];
    if (webApp == null) {
      html.window.alert('Ошибка: объект WebApp не найден.');
      return null;
    }

    // Проверяем, существует ли функция ready, и если да, вызываем её
    var readyProp = js_util.getProperty(webApp, 'ready');
    if (readyProp is Function) {
      // Если ready возвращает Promise, ждём его завершения
      await js_util.promiseToFuture(readyProp([]));
    } else {
      html.window.console
          .log('Свойство "ready" не является функцией, пропускаем вызов.');
    }

    // Получаем initDataUnsafe
    var initDataUnsafe = js_util.getProperty(webApp, 'initDataUnsafe');
    if (initDataUnsafe == null) {
      html.window.alert('Ошибка: initDataUnsafe отсутствует.');
      return null;
    }

    // Если initDataUnsafe не строка, сериализуем его
    String initDataStr;
    if (initDataUnsafe is String) {
      initDataStr = initDataUnsafe;
    } else {
      initDataStr = js.context.callMethod('JSON.stringify', [initDataUnsafe]);
    }

    if (initDataStr.isEmpty) {
      html.window.alert('Ошибка: Данные не получены от Telegram.');
      return null;
    }

    // Декодируем данные
    String decodedData = Uri.decodeComponent(initDataStr);
    Map<String, dynamic> initData = jsonDecode(decodedData);

    if (initData.containsKey('user')) {
      return Map<String, dynamic>.from(initData['user']);
    } else {
      html.window.alert(
          'Ошибка: Данные пользователя не найдены в initDataUnsafe.\nПолные данные: $decodedData');
      return null;
    }
  } catch (e) {
    html.window.alert('Ошибка получения данных Telegram: $e');
    return null;
  }
}

/// Возвращает Telegram ID пользователя в виде строки, если доступен.
Future<String?> getTelegramUserId() async {
  try {
    var userData = await getTelegramUserData();
    var id = userData?['id']?.toString();
    if (id == null) {
      html.window.alert('Ошибка: Telegram User ID не получен.');
    }
    return id;
  } catch (e) {
    html.window.alert('Ошибка получения Telegram User ID: $e');
    return null;
  }
}

/// Возвращает username пользователя Telegram, если доступен.
Future<String?> getTelegramUsername() async {
  try {
    var userData = await getTelegramUserData();
    var username = userData?['username'];
    if (username == null) {
      html.window.alert('Ошибка: Telegram username не получен.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка получения Telegram username: $e');
    return null;
  }
}
