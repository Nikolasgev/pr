import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:per_shop/core/constants/app_constants.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение списка товаров из Firestore
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.firebaseCollectionProducts)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Добавляем идентификатор документа
        return data;
      }).toList();
    } catch (error) {
      throw Exception("Ошибка получения товаров: $error");
    }
  }

  // Логика создания заказа в Firestore
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _firestore
          .collection(AppConstants.firebaseCollectionOrders)
          .add(orderData);
    } catch (error) {
      throw Exception("Ошибка создания заказа: $error");
    }
  }
}
