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
    return null;
  }

  // Получаем объект WebApp: Telegram.WebApp
  final webApp = getProperty(telegram, 'WebApp');
  if (webApp == null) {
    return null;
  }

  // Вызываем ready(), чтобы сообщить Telegram, что приложение готово.
  if (hasProperty(webApp, 'ready')) {
    callMethod(webApp, 'ready', []);
  }

  // Ждем немного для загрузки данных.
  await Future.delayed(Duration(milliseconds: 300));

  // Получаем initDataUnsafe, который должен содержать данные о пользователе.
  final initDataUnsafe = getProperty(webApp, 'initDataUnsafe');
  if (initDataUnsafe == null) {
    return null;
  }

  // Для сериализации используем объект JSON из window.
  final jsonObject = getProperty(html.window, 'JSON');
  // Преобразуем initDataUnsafe в JSON-строку.
  String initDataJson = callMethod(jsonObject, 'stringify', [initDataUnsafe]);

  // Проверяем, что initDataUnsafe содержит свойство "user".
  if (!hasProperty(initDataUnsafe, 'user')) {
    html.window.alert(
        'Ошибка: Запустите приложение внутри Telegram. Мы не сможем отправлять информацию об этом заказе к вам в Telegram, поэтому просим для отслеживания заказа сохраните его ID.');
    return null;
  }
  // Извлекаем объект user.
  final userObj = getProperty(initDataUnsafe, 'user');

  // Преобразуем userObj в строку JSON и декодируем в Map.
  String userJson = callMethod(jsonObject, 'stringify', [userObj]);
  Map<String, dynamic> userData = jsonDecode(userJson);

  return userData;
}

/// Возвращает Telegram User ID как строку.
Future<String?> fetchTelegramUserId() async {
  final userData = await fetchTelegramUserData();
  if (userData != null && userData.containsKey('id')) {
    String id = userData['id'].toString();
    return id;
  } else {
    return null;
  }
}

/// Возвращает Telegram username.
Future<String?> fetchTelegramUsername() async {
  final userData = await fetchTelegramUserData();
  if (userData != null && userData.containsKey('username')) {
    String username = userData['username'];
    return username;
  } else {
    return null;
  }
}

void main() {
  // Пример вызова для отладки:
  fetchTelegramUserData().then((data) {});
}
