import 'package:flutter/material.dart';
import 'package:per_shop/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:per_shop/injection_container.dart';

import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Если ширина экрана больше 600 пикселей, используем двухколоночный макет
          if (constraints.maxWidth > 600) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Левая колонка с изображением
                  Expanded(
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                      height: constraints.maxHeight * 0.6,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Правая колонка с деталями товара
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(product.description),
                        const SizedBox(height: 8),
                        Text(
                          '\$${product.price.toString()}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Для узких экранов используем вертикальный список
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toString()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
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
    );
  }
}
