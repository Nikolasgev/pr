import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:js_util' as js_util;

/// Асинхронно получает данные пользователя из Telegram Mini Apps.
/// Если данные не получены, выводит alert с информацией об ошибке.
Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    // Получаем объект Telegram
    var telegram = js.context['Telegram'];
    html.window.console.log('telegram object: $telegram');
    if (telegram == null) {
      html.window.alert('Запустите приложение внутри Telegram!');
      return null;
    }

    // Получаем объект WebApp
    var webApp = telegram['WebApp'];
    html.window.console.log('webApp object: $webApp');
    if (webApp == null) {
      html.window.alert('Ошибка: объект WebApp не найден.');
      return null;
    }

    // Выводим ключи объекта WebApp для отладки
    var keys = js.context.callMethod('Object.keys', [webApp]);
    html.window.console.log('WebApp keys: $keys');

    // Пытаемся получить данные: сначала initDataUnsafe, если его нет – initData
    var initData = js_util.getProperty(webApp, 'initDataUnsafe') ??
        js_util.getProperty(webApp, 'initData');
    html.window.console.log('initData: $initData');
    if (initData == null || (initData is String && initData.isEmpty)) {
      html.window.alert('Ошибка: initData отсутствует.');
      return null;
    }

    // Если полученные данные не строка, сериализуем их через JSON.stringify
    String initDataStr;
    if (initData is String) {
      initDataStr = initData;
    } else {
      initDataStr = js.context.callMethod('JSON.stringify', [initData]);
    }

    if (initDataStr.isEmpty) {
      html.window.alert('Ошибка: Данные не получены от Telegram.');
      return null;
    }

    // Декодируем строку, сначала через Uri.decodeComponent, затем через jsonDecode
    String decodedData = Uri.decodeComponent(initDataStr);
    Map<String, dynamic> initDataMap = jsonDecode(decodedData);
    html.window.console.log('initDataMap: $initDataMap');

    if (initDataMap.containsKey('user')) {
      return Map<String, dynamic>.from(initDataMap['user']);
    } else {
      html.window.alert(
          'Ошибка: Данные пользователя не найдены.\nПолные данные: $decodedData');
      return null;
    }
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
    var id = userData?['id']?.toString();
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
    var username = userData?['username'];
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
