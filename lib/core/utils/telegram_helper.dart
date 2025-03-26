import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js_util';

/// Получает данные пользователя из Telegram.WebApp.
/// Работает только при запуске мини-приложения внутри Telegram.
Future<Map<String, dynamic>?> fetchTelegramUserData() async {
  // Ждем, чтобы Telegram успел инициализировать объект WebApp.
  await Future.delayed(Duration(milliseconds: 400));

  // Получаем глобальный объект Telegram через js_util.getProperty.
  final telegram = getProperty(html.window, 'Telegram');
  if (telegram == null) {
    html.window.alert(
        'Ошибка: объект Telegram не найден. Запустите приложение внутри Telegram.');
    return null;
  }
  html.window.console.log('Найден объект Telegram.');

  // Получаем объект WebApp: Telegram.WebApp
  final webApp = getProperty(telegram, 'WebApp');
  if (webApp == null) {
    html.window.alert('Ошибка: Telegram.WebApp не найден.');
    return null;
  }
  html.window.console.log('Найден объект Telegram.WebApp.');

  // Вызываем ready(), чтобы сообщить Telegram, что приложение готово.
  if (hasProperty(webApp, 'ready')) {
    callMethod(webApp, 'ready', []);
    html.window.console.log('Метод ready() вызван.');
  }

  // Ждем немного для загрузки данных.
  await Future.delayed(Duration(milliseconds: 300));

  // Получаем initDataUnsafe, который должен содержать данные о пользователе.
  final initDataUnsafe = getProperty(webApp, 'initDataUnsafe');
  if (initDataUnsafe == null) {
    html.window.alert('Ошибка: initDataUnsafe отсутствует.');
    return null;
  }
  html.window.console.log('Получен initDataUnsafe.');

  // Для сериализации используем объект JSON из window.
  final jsonObject = getProperty(html.window, 'JSON');
  // Преобразуем initDataUnsafe в JSON-строку.
  String initDataJson = callMethod(jsonObject, 'stringify', [initDataUnsafe]);
  html.window.console.log('initDataUnsafe JSON: $initDataJson');

  // Проверяем, что initDataUnsafe содержит свойство "user".
  if (!hasProperty(initDataUnsafe, 'user')) {
    html.window
        .alert('Ошибка: данные о пользователе отсутствуют в initDataUnsafe.');
    return null;
  }
  // Извлекаем объект user.
  final userObj = getProperty(initDataUnsafe, 'user');
  html.window.console.log('Данные пользователя: $userObj');

  // Преобразуем userObj в строку JSON и декодируем в Map.
  String userJson = callMethod(jsonObject, 'stringify', [userObj]);
  Map<String, dynamic> userData = jsonDecode(userJson);
  html.window.console.log('Преобразованные данные пользователя: $userData');

  return userData;
}

/// Возвращает Telegram User ID как строку.
Future<String?> fetchTelegramUserId() async {
  final userData = await fetchTelegramUserData();
  if (userData != null && userData.containsKey('id')) {
    String id = userData['id'].toString();
    html.window.console.log('Telegram User ID: $id');
    return id;
  } else {
    html.window.alert('Ошибка: не удалось получить User ID.');
    return null;
  }
}

/// Возвращает Telegram username.
Future<String?> fetchTelegramUsername() async {
  final userData = await fetchTelegramUserData();
  if (userData != null && userData.containsKey('username')) {
    String username = userData['username'];
    html.window.console.log('Telegram username: $username');
    return username;
  } else {
    html.window.alert('Ошибка: не удалось получить username.');
    return null;
  }
}

void main() {
  // Пример вызова для отладки:
  fetchTelegramUserData().then((data) {
    html.window.console.log('User data: $data');
  });
}
