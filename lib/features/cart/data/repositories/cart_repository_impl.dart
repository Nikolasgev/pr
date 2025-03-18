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

  Future<void> addProduct(Product product) async {
    final index =
        _cart.items.indexWhere((item) => item.product.id == product.id);
    List<CartItem> updatedItems = List.from(_cart.items);
    if (index == -1) {
      updatedItems.add(CartItem(product: product, quantity: 1));
    } else {
      final currentItem = updatedItems[index];
      updatedItems[index] = CartItem(
          product: currentItem.product, quantity: currentItem.quantity + 1);
    }
    _cart = Cart(items: updatedItems);
  }

  Future<void> removeProduct(Product product) async {
    List<CartItem> updatedItems =
        _cart.items.where((item) => item.product.id != product.id).toList();
    _cart = Cart(items: updatedItems);
  }

  Future<void> updateProduct(Product product, int quantity) async {
    List<CartItem> updatedItems = List.from(_cart.items);
    final index =
        updatedItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (quantity <= 0) {
        updatedItems.removeAt(index);
      } else {
        updatedItems[index] = CartItem(product: product, quantity: quantity);
      }
      _cart = Cart(items: updatedItems);
    }
  }
}
