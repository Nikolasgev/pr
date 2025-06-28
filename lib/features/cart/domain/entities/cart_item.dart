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

  double get unitPrice =>
      product.priceFor(selectedVolume ?? product.volumes.first);

  double get totalPrice => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product']),
        quantity: json['quantity'] as int? ?? 0,
        selectedVolume: json['selectedVolume'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'selectedVolume': selectedVolume,
      };
}
