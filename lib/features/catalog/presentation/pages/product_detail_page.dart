import 'package:flutter/material.dart';

import '../../../../injection_container.dart';
import '../../../cart/presentation/blocs/cart_bloc.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.imageUrl),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(product.description),
            const SizedBox(height: 8),
            Text('\$${product.price.toString()}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Отправляем событие добавления товара в корзину
                sl<CartBloc>().add(AddProductToCart(product: product));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} добавлен в корзину')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Добавить в корзину'),
            ),
          ],
        ),
      ),
    );
  }
}
