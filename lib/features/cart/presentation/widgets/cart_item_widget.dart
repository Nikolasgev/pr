import 'package:flutter/material.dart';

import '../../domain/entities/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(cartItem.product.imageUrl),
        title: Text(cartItem.product.name),
        subtitle: Text('Quantity: ${cartItem.quantity}'),
        trailing: Text(
            '\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
      ),
    );
  }
}
