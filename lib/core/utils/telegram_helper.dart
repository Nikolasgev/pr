import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

/// Возвращает объект пользователя из Telegram WebApp.
/// Если возникает ошибка или данные отсутствуют, выводит alert с сообщением об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Получаем объект Telegram через dart:js
    final telegram = js.context['Telegram'];
    if (telegram == null) {
      html.window.alert(
          'Ошибка: не удалось получить объект Telegram. Убедитесь, что приложение запущено в Telegram.');
      return null;
    }

    final webApp = telegram['WebApp'];
    if (webApp == null) {
      html.window
          .alert('Ошибка: не удалось получить объект WebApp из Telegram.');
      return null;
    }

    final initDataUnsafe = webApp['initDataUnsafe'];
    if (initDataUnsafe == null) {
      html.window.alert(
          'Ошибка: не удалось получить initDataUnsafe из Telegram WebApp.');
      return null;
    }

    final user = initDataUnsafe['user'];
    if (user == null) {
      html.window.alert(
          'Ошибка: не удалось получить данные пользователя из Telegram WebApp.');
      return null;
    }

    // Преобразуем полученные данные в Map<String, dynamic>
    final data = Map<String, dynamic>.from(user);
    return data;
  } catch (e) {
    html.window.alert('Ошибка при получении данных Telegram: $e');
    return null;
  }
}

/// Возвращает Telegram ID пользователя в виде строки, если доступен.
/// В случае ошибки выводит alert.
Future<String?> getTelegramUserId() async {
  try {
    final userData = await getTelegramUserData();
    final id = userData?['id']?.toString();
    if (id == null) {
      html.window.alert('Ошибка: Telegram User ID не получен.');
    }
    return id;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram User ID: $e');
    return null;
  }
}

/// Возвращает username пользователя Telegram, если доступен.
/// В случае ошибки выводит alert.
Future<String?> getTelegramUsername() async {
  try {
    final userData = await getTelegramUserData();
    final username = userData?['username'];
    if (username == null) {
      html.window.alert('Ошибка: Telegram username не получен.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram username: $e');
    return null;
  }
}
