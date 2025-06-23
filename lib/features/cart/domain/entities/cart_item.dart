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
    final productJson = json['product'] as Map<String, dynamic>? ?? json;

    return CartItem(
      product: Product.fromJson(productJson),
      quantity: json['quantity'] as int? ?? 0,
      selectedVolume: json['selectedVolume'] as String?,
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
