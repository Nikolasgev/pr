import '../../../catalog/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedVolume; // выбранный объём товара

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedVolume,
  });
}
