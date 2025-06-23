import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart' as order;
import 'package:per_shop/features/cart/domain/entities/cart_item.dart';

class OrderSuccessPageFromId extends StatelessWidget {
  final String orderId;

  const OrderSuccessPageFromId({Key? key, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
      builder: (context, snapshot) {
        // 1) ждем данных
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 2) нет документа
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Заказ не найден')),
          );
        }
        // 3) документ есть — разобрали его явно, id берем из snapshot.id
        final raw = snapshot.data!.data()! as Map<String, dynamic>;
        final loadedOrder = order.Order(
          id: snapshot.data!.id,
          clientName: raw['clientName'] ?? '',
          address: raw['address'] ?? '',
          phone: raw['phone'] ?? '',
          email: raw['email'] ?? '',
          comments: raw['comments'] ?? '',
          status: raw['status'] ?? '',
          telegramUserId: raw['telegramUserId'] as String?,
          telegramUsername: raw['telegramUsername'] as String?,
          price: (raw['price'] ?? 0).toDouble(),
          items: (raw['items'] as List<dynamic>? ?? [])
              .map((item) {
                final m = item as Map<String, dynamic>;
                // CartItem.fromJson из вашего домена
                return CartItem.fromJson(m);
              })
              .toList(),
        );

        // 4) строим экран успеха
        return Scaffold(
          appBar: AppBar(title: Text('Заказ №${loadedOrder.id}')),
          body: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 80, color: Colors.green),
                  const SizedBox(height: 24),
                  Text(
                    'Спасибо, ${loadedOrder.clientName}!\n'
                    'Ваш заказ №${loadedOrder.id} на сумму '
                    '${loadedOrder.price.toStringAsFixed(2)}₽ успешно оформлен.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (route) => false);
                    },
                    child: const Text('Вернуться к покупкам'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
