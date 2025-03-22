import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../blocs/catalog_bloc.dart';
import '../widgets/product_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatalogBloc>()..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Catalog'),
          leading: IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.pushNamed(context, '/admin'),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => Navigator.pushNamed(context, '/cart'),
            )
          ],
        ),
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            if (state is CatalogLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CatalogLoaded) {
              // Собираем уникальные категории
              final categories = <String>{'All'};
              for (var product in state.products) {
                categories.add(product.category);
              }
              final categoryList = categories.toList();

              // Фильтруем товары по выбранной категории
              final filteredProducts = selectedCategory == 'All'
                  ? state.products
                  : state.products
                      .where((p) => p.category == selectedCategory)
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categoryList[index];
                        final isSelected = category == selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                            child: Text('No products found in this category'))
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              itemCount: filteredProducts.length,
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent:
                                    300, // максимальная ширина карточки, подбирайте по вкусу
                                mainAxisSpacing: 12.0,
                                crossAxisSpacing: 8.0,
                                childAspectRatio: 9 / 10,
                              ),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                    product: filteredProducts[index]);
                              },
                            )),
                  ),
                ],
              );
            } else if (state is CatalogError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
