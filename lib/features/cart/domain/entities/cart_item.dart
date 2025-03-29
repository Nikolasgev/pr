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

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': quantity,
      'selectedVolume': selectedVolume,
    };
  }
}
