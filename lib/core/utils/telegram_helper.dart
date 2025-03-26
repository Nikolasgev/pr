import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

/// Асинхронно получает данные пользователя из Telegram WebApp.
/// Если данные не получены, выводит alert с информацией об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Ждем, чтобы убедиться, что страница полностью загружена и Telegram инициализирован
    await Future.delayed(Duration(milliseconds: 300));

    // Проверяем наличие объекта Telegram
    if (!js.context.hasProperty('Telegram')) {
      html.window.alert(
          'Ошибка: Telegram object отсутствует. Запустите приложение внутри Telegram.');
      return null;
    }
    var telegram = js.context['Telegram'];
    html.window.console.log('telegram object: $telegram');

    // Проверяем наличие объекта Telegram.WebApp
    if (!js_util.hasProperty(telegram, 'WebApp')) {
      html.window.alert('Ошибка: WebApp object отсутствует.');
      return null;
    }
    var webApp = js_util.getProperty(telegram, 'WebApp');
    html.window.console.log('webApp object: $webApp');

    // Вызываем ready(), чтобы Telegram знал, что приложение готово
    if (js_util.hasProperty(webApp, 'ready')) {
      js_util.callMethod(webApp, 'ready', []);
    }

    // Даем немного времени для инициализации данных
    await Future.delayed(Duration(milliseconds: 300));

    // Пытаемся получить данные через initDataUnsafe
    if (!js_util.hasProperty(webApp, 'initDataUnsafe')) {
      html.window.alert('Ошибка: initDataUnsafe отсутствует.');
      return null;
    }
    var initDataUnsafe = js_util.getProperty(webApp, 'initDataUnsafe');
    html.window.console.log('initDataUnsafe object: $initDataUnsafe');

    // Логируем JSON-строку полученных данных для отладки
    var initDataJson =
        js.context.callMethod('JSON.stringify', [initDataUnsafe]);
    html.window.console.log('initDataUnsafe JSON: $initDataJson');

    // Проверяем, что initDataUnsafe содержит ключ "user"
    if (!js_util.hasProperty(initDataUnsafe, 'user')) {
      html.window.alert(
          'Ошибка: initDataUnsafe не содержит ключ "user". Полученные данные: $initDataJson');
      return null;
    }
    var user = js_util.getProperty(initDataUnsafe, 'user');
    html.window.console.log('user object: $user');
    if (user == null) {
      html.window
          .alert('Ошибка: user равен null. Полные данные: $initDataJson');
      return null;
    }

    // Преобразуем объект user в JSON-строку и декодируем в Map<String, dynamic>
    String userJson = js.context.callMethod('JSON.stringify', [user]);
    Map<String, dynamic> userMap = jsonDecode(userJson);
    html.window.console.log('User data map: $userMap');
    return userMap;
  } catch (e) {
    html.window.alert('Ошибка получения данных Telegram: $e');
    html.window.console.log('Exception in getTelegramUserData: $e');
    return null;
  }
}

/// Асинхронно возвращает Telegram User ID в виде строки, если доступен.
Future<String?> getTelegramUserId() async {
  try {
    var userData = await getTelegramUserData();
    var id = userData != null ? userData['id']?.toString() : null;
    html.window.console.log('Telegram User ID: ${id ?? 'null'}');
    if (id == null) {
      html.window.alert('Ошибка: Telegram User ID не получен.');
    }
    return id;
  } catch (e) {
    html.window.alert('Ошибка получения Telegram User ID: $e');
    return null;
  }
}

/// Асинхронно возвращает Telegram username, если доступен.
Future<String?> getTelegramUsername() async {
  try {
    var userData = await getTelegramUserData();
    var username = userData != null ? userData['username'] : null;
    html.window.console.log('Telegram username: ${username ?? 'null'}');
    if (username == null) {
      html.window.alert('Ошибка: Telegram username не получен.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка получения Telegram username: $e');
    return null;
  }
}
