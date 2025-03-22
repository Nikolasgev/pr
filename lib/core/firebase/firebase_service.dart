import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:per_shop/core/constants/app_constants.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  // Получение списка товаров (уже есть)
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot itemsSnapshot =
          await _firestore.collectionGroup('items').get();

      List<Map<String, dynamic>> products = itemsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      return products;
    } catch (error) {
      throw Exception("Ошибка получения товаров: $error");
    }
  }

  // Создание заказа (уже есть)
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .add(orderData);
    } catch (error) {
      throw Exception("Ошибка создания заказа: $error");
    }
  }

  // Новый метод получения заказов
  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception("Ошибка получения заказов: $e");
    }
  }
}
