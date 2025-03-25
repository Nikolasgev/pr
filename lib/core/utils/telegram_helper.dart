import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

/// Асинхронно получает объект пользователя из Telegram WebApp.
/// Если данные не получены, выводит alert с сообщением об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Получаем объект Telegram через dart:js
    var telegram = js.context['Telegram'];
    html.window.console.log('telegram object: $telegram');
    if (telegram == null) {
      html.window.alert(
          'Ошибка: Telegram object is null. Убедитесь, что приложение запущено внутри Telegram.');
      return null;
    }

    var webApp = telegram['WebApp'];
    html.window.console.log('webApp object: $webApp');
    if (webApp == null) {
      html.window.alert('Ошибка: WebApp object is null.');
      return null;
    }

    var initDataUnsafe = webApp['initDataUnsafe'];
    var initDataJson =
        js.context.callMethod('JSON.stringify', [initDataUnsafe]);
    html.window.console.log('initDataUnsafe: $initDataJson');
    if (initDataUnsafe == null) {
      html.window.alert('Ошибка: initDataUnsafe is null.');
      return null;
    }

    var user = initDataUnsafe['user'];
    html.window.console
        .log('user object: ${user != null ? user.toString() : 'null'}');
    if (user == null) {
      html.window.alert(
          'Ошибка: user property is null. Full initDataUnsafe: $initDataJson');
      return null;
    }

    // Преобразуем user в Map<String, dynamic> с помощью JSON.stringify и jsonDecode.
    Map<String, dynamic> userMap =
        jsonDecode(js.context.callMethod('JSON.stringify', [user]));
    html.window.console.log('User data map: $userMap');
    return userMap;
  } catch (e) {
    html.window.alert('Exception while getting Telegram user data: $e');
    html.window.console.log('Exception in getTelegramUserData: $e');
    return null;
  }
}

/// Асинхронно возвращает Telegram ID пользователя в виде строки.
/// Если данные не получены, выводит alert.
Future<String?> getTelegramUserId() async {
  try {
    var userData = await getTelegramUserData();
    var id = userData?['id']?.toString();
    html.window.console.log('Telegram User ID: ${id ?? 'null'}');
    if (id == null) {
      html.window.alert('Ошибка: Telegram User ID is null.');
    }
    return id;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram User ID: $e');
    html.window.console.log('Exception in getTelegramUserId: $e');
    return null;
  }
}

/// Асинхронно возвращает Telegram username пользователя.
/// Если данные не получены, выводит alert.
Future<String?> getTelegramUsername() async {
  try {
    var userData = await getTelegramUserData();
    var username = userData?['username'];
    html.window.console.log('Telegram username: ' + (username ?? 'null'));
    if (username == null) {
      html.window.alert('Ошибка: Telegram username is null.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка при получении Telegram username: $e');
    html.window.console.log('Exception in getTelegramUsername: $e');
    return null;
  }
}
