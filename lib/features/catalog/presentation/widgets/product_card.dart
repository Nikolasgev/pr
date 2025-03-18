import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../../../cart/presentation/blocs/cart_bloc.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${product.price.toString()}'),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                // Отправляем событие добавления товара в корзину
                sl<CartBloc>().add(AddProductToCart(product: product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} добавлен в корзину')),
                );
              },
            ),
          ],
        ),
        onTap: () {
          // Переход к экрану детального просмотра товара с передачей объекта Product
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          );
        },
      ),
    );
  }
}
