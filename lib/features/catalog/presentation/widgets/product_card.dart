import 'package:flutter/material.dart';
import 'package:per_shop/core/widgets/custom_snack_bar_widget.dart';
import 'package:per_shop/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:per_shop/features/catalog/domain/entities/product.dart';
import 'package:per_shop/injection_container.dart';

/// Диалог выбора объёма товара, если он задан.
Future<String?> showVolumeSelectorDialog(
  BuildContext context,
  List<String> volumes, {
  String? initialValue,
}) {
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
                  .map(
                    (volume) => DropdownMenuItem<String>(
                      value: volume,
                      child: Text(volume),
                    ),
                  )
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

/// Адаптивная карточка товара.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  /// Обработчик добавления в корзину с учетом выбора объёма.
  void _handleAddToCart(BuildContext context) async {
    if (product.volume != null &&
        product.volume!.isNotEmpty &&
        product.volume!.length > 1) {
      final selectedVolume = await showVolumeSelectorDialog(
        context,
        product.volume!,
        initialValue: product.volume!.first,
      );
      if (selectedVolume != null) {
        sl<CartBloc>().add(AddProductToCart(
          product: product,
          selectedVolume: selectedVolume,
        ));
        ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
            message: '${product.name} ($selectedVolume) добавлен в корзину'));
      }
    } else {
      sl<CartBloc>().add(AddProductToCart(product: product));
      ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(message: '${product.name} добавлен в корзину'));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Используем GestureDetector для навигации по тапу и Card для оформления
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/product', arguments: product),
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение товара с фиксированным соотношением сторон (16:9)
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Текстовая информация: название и описание
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Ряд с ценой и кнопкой добавления в корзину
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${product.price}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const Text(
                            '₽',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    iconSize: 28,
                    color: Colors.green,
                    onPressed: () => _handleAddToCart(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
