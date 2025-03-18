import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:per_shop/core/firebase/firebase_service.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart';

class OrdersRepositoryImpl {
  final FirebaseService firebaseService = FirebaseService();

  Future<void> placeOrder(Order order) async {
    try {
      // Преобразуем заказ в Map, который соответствует структуре Firestore
      final orderData = {
        'clientName': order.clientName,
        'address': order.address,
        'phone': order.phone,
        'email': order.email,
        'comments': order.comments,
        'status': order.status,
        'items': order.items
            .map((item) => {
                  'id': item.product.id,
                  'name': item.product.name,
                  'description': item.product.description,
                  'price': item.product.price,
                  'quantity': item.quantity,
                  'imageUrl': item.product.imageUrl,
                  'category': item.product.category,
                })
            .toList(),
        'createdAt': FieldValue.serverTimestamp(), // Временная метка создания
      };

      await firebaseService.createOrder(orderData);
    } catch (error) {
      throw Exception("Ошибка создания заказа: $error");
    }
  }
}
