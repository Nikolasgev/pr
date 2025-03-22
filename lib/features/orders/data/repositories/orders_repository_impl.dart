import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:per_shop/core/constants/app_constants.dart';
import 'package:per_shop/core/firebase/firebase_service.dart';
import 'package:per_shop/features/cart/domain/entities/cart_item.dart';
import 'package:per_shop/features/catalog/domain/entities/product.dart';
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
        'items': order.items.map((item) {
          return {
            'id': item.product.id,
            'name': item.product.name,
            'description': item.product.description,
            'price': item.product.price,
            'quantity': item.quantity,
            'imageUrl': item.product.imageUrl,
            'category': item.product.category,
            'selectedVolume': item.selectedVolume,
          };
        }).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Используем set() с заданным идентификатором заказа, чтобы гарантированно сохранить все данные,
      // включая список товаров (items)
      await firebaseService.firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .doc(order.id)
          .set(orderData);
    } catch (error) {
      throw Exception("Ошибка создания заказа: $error");
    }
  }

  // Получение списка заказов
  Future<List<Order>> getOrders() async {
    try {
      final dataList = await firebaseService.getOrders();
      return dataList.map((data) {
        // Преобразование списка товаров из map в List<CartItem>
        final items = (data['items'] as List).map<CartItem>((item) {
          return CartItem(
            product: Product(
              id: item['id'],
              name: item['name'],
              description: item['description'],
              price: (item['price'] as num).toDouble(),
              imageUrl: item['imageUrl'],
              category: item['category'],
            ),
            quantity: item['quantity'],
            selectedVolume: item['selectedVolume'],
          );
        }).toList();
        return Order(
          id: data['id'],
          clientName: data['clientName'],
          address: data['address'],
          phone: data['phone'],
          email: data['email'],
          comments: data['comments'],
          items: items,
          status: data['status'],
        );
      }).toList();
    } catch (e) {
      throw Exception("Ошибка получения заказов: $e");
    }
  }

  // Обновление статуса заказа
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await firebaseService.firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .doc(orderId)
          .update({'status': newStatus});
    } catch (e) {
      throw Exception("Ошибка обновления статуса заказа: $e");
    }
  }

  // Удаление заказа
  Future<void> deleteOrder(String orderId) async {
    try {
      await firebaseService.firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .doc(orderId)
          .delete();
    } catch (e) {
      throw Exception("Ошибка удаления заказа: $e");
    }
  }
}
