import 'dart:async';

class FirebaseService {
  // Моковый метод для получения списка продуктов
  Future<List<Map<String, dynamic>>> getProducts() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        'id': '1',
        'name': 'Product 1',
        'description': 'Description 1',
        'price': 10.0,
        'imageUrl': 'https://via.placeholder.com/150',
        'category': 'Category A',
      },
      {
        'id': '2',
        'name': 'Product 2',
        'description': 'Description 2',
        'price': 20.0,
        'imageUrl': 'https://via.placeholder.com/150',
        'category': 'Category B',
      },
    ];
  }
}
