import '../../../catalog/domain/entities/product.dart';
import '../../data/repositories/cart_repository_impl.dart';

class AddToCart {
  final CartRepositoryImpl repository;
  AddToCart(this.repository);

  Future<void> call(Product product, {String? selectedVolume}) async {
    await repository.addProduct(product, selectedVolume: selectedVolume);
  }
}
