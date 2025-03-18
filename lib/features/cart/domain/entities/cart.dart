import 'cart_item.dart';

class Cart {
  List<CartItem> items;

  Cart({required this.items});

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);
}
