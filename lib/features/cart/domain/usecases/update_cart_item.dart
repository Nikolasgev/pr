import '../../../catalog/domain/entities/product.dart';
import '../../data/repositories/cart_repository_impl.dart';

class UpdateCartItem {
  final CartRepositoryImpl repository;
  UpdateCartItem(this.repository);

  Future<void> call(Product product, int quantity) async {
    await repository.updateProduct(product, quantity);
  }
}
