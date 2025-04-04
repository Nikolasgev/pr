import 'package:flutter/material.dart';
import 'package:per_shop/core/widgets/custom_action_button_widget.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart';

class OrderSuccessPage extends StatelessWidget {
  final Order order;
  const OrderSuccessPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Вычисляем общее количество товаров и итоговую сумму
    final totalQuantity =
        order.items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalPrice = order.items.fold<double>(
        0.0, (sum, item) => sum + item.product.price * item.quantity);

    // Базовая ширина для масштабирования (например, 375 пикселей)
    const baseWidth = 375.0;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Заказ оплачен'),
          automaticallyImplyLeading: false,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Если экран меньше 600 – используем его полную ширину, иначе фиксируем 600
            final effectiveWidth =
                constraints.maxWidth < 600 ? constraints.maxWidth : 600.0;
            // Вычисляем scaleFactor на основе effectiveWidth
            final scaleFactor = effectiveWidth / baseWidth;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: SizedBox(
                    width: effectiveWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Id заказа вверху
                          Text(
                            'ID заказа: ${order.id}',
                            style: TextStyle(
                              fontSize: 20 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32 * scaleFactor),
                          // Большая зеленая галочка
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 120 * scaleFactor,
                          ),
                          SizedBox(height: 32 * scaleFactor),
                          // Основная информация о заказе
                          Text(
                            order.clientName,
                            style: TextStyle(fontSize: 18 * scaleFactor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8 * scaleFactor),
                          Text(
                            order.address,
                            style: TextStyle(
                              fontSize: 16 * scaleFactor,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8 * scaleFactor),
                          Text(
                            'Сумма: ${totalPrice.toStringAsFixed(2)}₽',
                            style: TextStyle(
                              fontSize: 18 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8 * scaleFactor),
                          Text(
                            'Товары: $totalQuantity',
                            style: TextStyle(fontSize: 16 * scaleFactor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32 * scaleFactor),
                          CustomActionButton(
                            label: 'Вернуться к каталогу',
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context, '/',
                                  (Route<dynamic> route) => false);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
