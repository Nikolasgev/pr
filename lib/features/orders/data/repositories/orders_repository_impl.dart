import '../../domain/entities/order.dart';

class OrdersRepositoryImpl {
  // Заготовка для работы с заказами через Firebase
  Future<void> placeOrder(Order order) async {
    // Мокаем задержку и вывод в консоль
    await Future.delayed(Duration(seconds: 1));
    print("Order placed: ${order.id}");
  }
}
