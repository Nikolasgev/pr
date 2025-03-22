import 'package:flutter/material.dart';
import 'package:per_shop/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:per_shop/injection_container.dart';

import '../../domain/entities/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedVolume;

  @override
  void initState() {
    super.initState();
    // Если есть список объёмов, выбираем первый по умолчанию
    if (widget.product.volume != null && widget.product.volume!.isNotEmpty) {
      selectedVolume = widget.product.volume!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          Widget content;
          if (constraints.maxWidth > 600) {
            content = Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                      height: constraints.maxHeight * 0.6,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(widget.product.description),
                        const SizedBox(height: 8),
                        Text(
                          '\$${widget.product.price.toString()}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        // Если товар имеет варианты объёма, показываем селектор
                        if (widget.product.volume != null &&
                            widget.product.volume!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                const Text("Объем: "),
                                DropdownButton<String>(
                                  value: selectedVolume,
                                  items: widget.product.volume!
                                      .map((volume) => DropdownMenuItem<String>(
                                            value: volume,
                                            child: Text(volume),
                                          ))
                                      .toList(),
                                  onChanged: (newVolume) {
                                    setState(() {
                                      selectedVolume = newVolume;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product.description),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toString()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Если есть варианты объёма, добавляем селектор
                  if (widget.product.volume != null &&
                      widget.product.volume!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        children: [
                          const Text("Объем: "),
                          DropdownButton<String>(
                            value: selectedVolume,
                            items: widget.product.volume!
                                .map((volume) => DropdownMenuItem<String>(
                                      value: volume,
                                      child: Text(volume),
                                    ))
                                .toList(),
                            onChanged: (newVolume) {
                              setState(() {
                                selectedVolume = newVolume;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          return content;
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          // При добавлении передаём выбранный объем (если имеется)
          sl<CartBloc>().add(AddProductToCart(
            product: widget.product,
            selectedVolume: selectedVolume,
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${widget.product.name} добавлен в корзину')),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Добавить в корзину'),
      ),
    );
  }
}
