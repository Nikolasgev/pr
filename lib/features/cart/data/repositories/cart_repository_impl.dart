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
    if (index == -1) {
      _cart.items.add(CartItem(product: product, quantity: 1));
    } else {
      _cart.items[index].quantity++;
    }
  }

  Future<void> removeProduct(Product product) async {
    _cart.items.removeWhere((item) => item.product.id == product.id);
  }

  Future<void> updateProduct(Product product, int quantity) async {
    final index =
        _cart.items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart.items[index].quantity = quantity;
    }
  }
}
