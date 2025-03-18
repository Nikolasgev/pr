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
        'products': order.products
            .map((product) => {
                  'id': product.id,
                  'name': product.name,
                  'description': product.description,
                  'price': product.price,
                  'imageUrl': product.imageUrl,
                  'category': product.category,
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
