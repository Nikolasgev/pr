import 'package:per_shop/features/catalog/domain/entities/product.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';

class CartRepositoryImpl {
  CartRepositoryImpl() {
    _cart = Cart(items: []);
  }

  late Cart _cart;

  Future<Cart> getCart() async {
    return _cart;
  }

  Future<void> addProduct(Product product, {String? selectedVolume}) async {
    // Ищем товар с учетом выбранного объёма
    final index = _cart.items.indexWhere((item) =>
        item.product.id == product.id && item.selectedVolume == selectedVolume);
    List<CartItem> updatedItems = List.from(_cart.items);
    if (index == -1) {
      updatedItems.add(CartItem(
          product: product, quantity: 1, selectedVolume: selectedVolume));
    } else {
      final currentItem = updatedItems[index];
      updatedItems[index] = CartItem(
        product: currentItem.product,
        quantity: currentItem.quantity + 1,
        selectedVolume: currentItem.selectedVolume,
      );
    }
    _cart = Cart(items: updatedItems);
  }

  // Аналогично можно обновить removeProduct и updateProduct, если требуется учитывать объём
  Future<void> removeProduct(Product product, {String? selectedVolume}) async {
    List<CartItem> updatedItems = _cart.items
        .where((item) => !(item.product.id == product.id &&
            item.selectedVolume == selectedVolume))
        .toList();
    _cart = Cart(items: updatedItems);
  }

  Future<void> updateProduct(Product product, int quantity,
      {String? selectedVolume}) async {
    List<CartItem> updatedItems = List.from(_cart.items);
    final index = updatedItems.indexWhere((item) =>
        item.product.id == product.id && item.selectedVolume == selectedVolume);
    if (index != -1) {
      if (quantity <= 0) {
        updatedItems.removeAt(index);
      } else {
        updatedItems[index] = CartItem(
          product: product,
          quantity: quantity,
          selectedVolume: selectedVolume,
        );
      }
      _cart = Cart(items: updatedItems);
    }
  }
}
