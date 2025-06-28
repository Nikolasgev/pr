import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../blocs/cart_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(cartItem.product.imageUrl),
        title: Text(cartItem.product.name +
            (cartItem.selectedVolume != null
                ? " (${cartItem.selectedVolume})"
                : "")),
        subtitle: Text('Цена: ${cartItem.unitPrice.toStringAsFixed(2)}₽'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (cartItem.quantity > 1) {
                  context.read<CartBloc>().add(
                        UpdateProductInCart(
                          product: cartItem.product,
                          quantity: cartItem.quantity - 1,
                          selectedVolume: cartItem.selectedVolume,
                        ),
                      );
                } else {
                  context.read<CartBloc>().add(
                        RemoveProductFromCart(
                            product: cartItem.product,
                            selectedVolume: cartItem.selectedVolume),
                      );
                }
              },
            ),
            Text('${cartItem.quantity}'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.read<CartBloc>().add(
                      UpdateProductInCart(
                        product: cartItem.product,
                        quantity: cartItem.quantity + 1,
                        selectedVolume: cartItem.selectedVolume,
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
