import '../../../catalog/domain/entities/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? selectedVolume;

  CartItem({
    required this.product,
    required this.quantity,
    this.selectedVolume,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 0,
      selectedVolume: json['selectedVolume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedVolume': selectedVolume,
    };
  }
}
