import '../../../catalog/domain/entities/product.dart';
import '../../data/repositories/cart_repository_impl.dart';

class RemoveFromCart {
  final CartRepositoryImpl repository;
  RemoveFromCart(this.repository);

  Future<void> call(Product product) async {
    await repository.removeProduct(product);
  }
}
