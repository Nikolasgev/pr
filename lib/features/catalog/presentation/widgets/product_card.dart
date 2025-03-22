import 'package:flutter/material.dart';
import 'package:per_shop/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:per_shop/features/catalog/domain/entities/product.dart';
import 'package:per_shop/injection_container.dart';

/// Диалог выбора объёма товара
Future<String?> showVolumeSelectorDialog(
    BuildContext context, List<String> volumes,
    {String? initialValue}) {
  String? tempSelected = initialValue ?? volumes.first;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Выберите объем"),
            content: DropdownButton<String>(
              value: tempSelected,
              items: volumes
                  .map((volume) => DropdownMenuItem<String>(
                        value: volume,
                        child: Text(volume),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  tempSelected = newValue;
                });
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Отмена"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, tempSelected),
                child: const Text("Выбрать"),
              ),
            ],
          );
        },
      );
    },
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double cardHeight = constraints.maxHeight;
      // Пропорции: 63% под изображение, 37% под контент
      const double imageFraction = 0.68;
      const double contentFraction = 0.32;

      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/product',
            arguments: product,
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Изображение товара
              Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                height: cardHeight * imageFraction,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              // Информация о товаре
              Container(
                height: cardHeight * contentFraction,
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FittedBox(
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${product.price}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: () async {
                                // Проверяем, заполнено ли поле объема.
                                if (product.volume != null &&
                                    product.volume!.isNotEmpty) {
                                  print('volume is NOT EMPTY');
                                  // Показываем диалог выбора объема.
                                  final selectedVolume =
                                      await showVolumeSelectorDialog(
                                    context,
                                    product.volume!,
                                    initialValue: product.volume!.first,
                                  );
                                  if (selectedVolume != null) {
                                    sl<CartBloc>().add(AddProductToCart(
                                      product: product,
                                      selectedVolume: selectedVolume,
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${product.name} ($selectedVolume) добавлен в корзину'),
                                      ),
                                    );
                                  }
                                } else {
                                  print('volume is EMPTY');
                                  sl<CartBloc>()
                                      .add(AddProductToCart(product: product));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${product.name} добавлен в корзину'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
