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
        title: Text(cartItem.product.name),
        subtitle: Text('Price: \$${cartItem.product.price.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Кнопка "минус"
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (cartItem.quantity > 1) {
                  context.read<CartBloc>().add(
                        UpdateProductInCart(
                          product: cartItem.product,
                          quantity: cartItem.quantity - 1,
                        ),
                      );
                } else {
                  // Если количество равно 1, удаляем товар из корзины
                  context.read<CartBloc>().add(
                        RemoveProductFromCart(product: cartItem.product),
                      );
                }
              },
            ),
            // Отображаем текущее количество
            Text('${cartItem.quantity}'),
            // Кнопка "плюс"
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.read<CartBloc>().add(
                      UpdateProductInCart(
                        product: cartItem.product,
                        quantity: cartItem.quantity + 1,
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
