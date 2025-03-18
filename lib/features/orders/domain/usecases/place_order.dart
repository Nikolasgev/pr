import '../entities/order.dart';
import '../../data/repositories/orders_repository_impl.dart';

class PlaceOrder {
  final OrdersRepositoryImpl repository;
  PlaceOrder(this.repository);

  Future<void> call(Order order) async {
    await repository.placeOrder(order);
  }
}
