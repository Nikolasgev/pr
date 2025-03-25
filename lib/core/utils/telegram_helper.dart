import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:js' as js;

Future<Map<String, dynamic>?> getTelegramUserData() async {
  try {
    await js.context['Telegram']['WebApp']['ready']();
    if (!js.context.hasProperty('Telegram')) {
      html.window.alert('Запустите приложение внутри Telegram!');
      return null;
    }

    String initDataUnsafe = js.context['Telegram']['WebApp']['initDataUnsafe'];
    if (initDataUnsafe.isEmpty) {
      html.window.alert('Ошибка: initDataUnsafe пуст');
      return null;
    }

    String decodedData = Uri.decodeComponent(initDataUnsafe);
    Map<String, dynamic> initData = jsonDecode(decodedData);
    Map<String, dynamic>? user = initData['user'];
    if (user == null) {
      html.window.alert('Ошибка: Данные пользователя отсутствуют');
      return null;
    }

    return user;
  } catch (e) {
    html.window.alert('Ошибка: $e');
    return null;
  }
}

Future<String?> getTelegramUserId() async {
  try {
    var userData = await getTelegramUserData();
    return userData?['id']?.toString();
  } catch (e) {
    html.window.alert('Ошибка при получении ID: $e');
    return null;
  }
}

Future<String?> getTelegramUsername() async {
  try {
    var userData = await getTelegramUserData();
    return userData?['username'];
  } catch (e) {
    html.window.alert('Ошибка при получении username: $e');
    return null;
  }
}
