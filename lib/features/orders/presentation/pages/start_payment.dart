import 'dart:convert';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;   // ← только для Web
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> startPayment(
  BuildContext context,
  String orderId,
) async {
  try {
    final uri = Uri.parse(
      'https://us-central1-periche-tg-shop.cloudfunctions.net/initialPayment',
    );
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'order_id': orderId}),
    );
    if (resp.statusCode != 200) {
      throw Exception('Status ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final paymentUrl = data['url'] as String?;
    if (paymentUrl == null) {
      throw Exception('No payment URL returned');
    }

    // Перенаправляем браузер на страницу ЮKassa
    html.window.location.assign(paymentUrl);
  } catch (e) {
    debugPrint('Ошибка оплаты: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Не удалось перейти к оплате')),
    );
  }
}
