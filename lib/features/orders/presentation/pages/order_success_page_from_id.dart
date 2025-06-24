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
    final theme = Theme.of(context);
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('Заказ не найден')),
          );
        }

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
          items: (raw['items'] as List<dynamic>? ?? []).map((item) {
            final m = item as Map<String, dynamic>;
            return CartItem.fromJson(m);
          }).toList(),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Спасибо, ${loadedOrder.clientName}!'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ваш заказ №${loadedOrder.id} оформлен',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Сумма к оплате: ${loadedOrder.price.toStringAsFixed(2)}₽',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: loadedOrder.items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, idx) {
                      final item = loadedOrder.items[idx];
                      final volumeText = item.selectedVolume ??
                          item.product.volume?.first ??
                          '';
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              '${item.product.name} ($volumeText мл)',
                              style: theme.textTheme.bodyLarge,
                            ),

                          ],
                        ),
                        subtitle: Text('× ${item.quantity}'),
                        trailing: Text(
                          '${(item.product.price * item.quantity).toStringAsFixed(2)}₽',
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 32),
                Text(
                  'Итого: ${loadedOrder.price.toStringAsFixed(2)}₽',
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                  child: const Text(
                    'Вернуться к покупкам',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
