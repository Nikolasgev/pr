import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

/// Асинхронно получает данные пользователя из Telegram WebApp.
/// Если данные не получены, выводит alert с информацией об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Получаем объект Telegram через dart:js
    var telegram = js.context['Telegram'];
    html.window.console.log('telegram object: $telegram');
    if (telegram == null) {
      html.window.alert(
          'Ошибка: Telegram object отсутствует. Запустите приложение внутри Telegram.');
      return null;
    }

    // Получаем объект WebApp
    var webApp = telegram['WebApp'];
    html.window.console.log('webApp object: $webApp');
    if (webApp == null) {
      html.window.alert('Ошибка: WebApp object отсутствует.');
      return null;
    }

    // Пытаемся получить данные через initDataUnsafe
    var initDataUnsafe = webApp['initDataUnsafe'];
    html.window.console.log('initDataUnsafe object: $initDataUnsafe');
    if (initDataUnsafe == null) {
      html.window.alert('Ошибка: initDataUnsafe отсутствует.');
      return null;
    }

    // Выводим полностью полученные данные для отладки
    var initDataJson =
        js.context.callMethod('JSON.stringify', [initDataUnsafe]);
    html.window.console.log('initDataUnsafe JSON: $initDataJson');

    // Пробуем получить ключ "user" из initDataUnsafe
    if (!initDataUnsafe.hasProperty('user')) {
      html.window.alert(
          'Ошибка: initDataUnsafe не содержит ключ "user". Полученные данные: $initDataJson');
      return null;
    }
    var user = initDataUnsafe['user'];
    html.window.console
        .log('user object: ${user != null ? user.toString() : 'null'}');
    if (user == null) {
      html.window
          .alert('Ошибка: user равен null. Полные данные: $initDataJson');
      return null;
    }

    // Преобразуем user в Map<String, dynamic> с помощью JSON.stringify и jsonDecode
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
    html.window.console.log('Telegram username: ' + (username ?? 'null'));
    if (username == null) {
      html.window.alert('Ошибка: Telegram username не получен.');
    }
    return username;
  } catch (e) {
    html.window.alert('Ошибка получения Telegram username: $e');
    return null;
  }
}

/// Проверка наличия свойства в объекте js (поскольку объекты js не имеют метода hasProperty напрямую)
extension JsObjectExt on Object {
  bool hasProperty(String key) {
    try {
      // Если попытка получить свойство не выбросит исключение, значит свойство существует
      js_util.getProperty(this, key);
      return true;
    } catch (_) {
      return false;
    }
  }
}
