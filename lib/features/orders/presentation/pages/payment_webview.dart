import 'dart:convert';
import 'dart:html' as html;        // <-- Для Web
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:per_shop/features/orders/domain/entities/order.dart';

Future<void> startPayment(
  BuildContext context,
  String orderId,
  Order order,
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
      throw Exception('status ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final paymentUrl = data['url'] as String?;
    if (paymentUrl == null) {
      throw Exception('No url in response');
    }

    // Перенаправляем браузер
    html.window.location.assign(paymentUrl);
  } catch (e) {
    debugPrint('Ошибка оплаты: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Не удалось перейти к оплате')),
    );
  }
}
