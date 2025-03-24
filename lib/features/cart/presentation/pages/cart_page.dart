import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../blocs/cart_bloc.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CartBloc>()..add(LoadCart()),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Корзина'),
              ),
              body: () {
                if (state is CartLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CartLoaded) {
                  if (state.cart.items.isEmpty) {
                    return Center(child: Text('Корзина пуста'));
                  }
                  return ListView.builder(
                    itemCount: state.cart.items.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(cartItem: state.cart.items[index]);
                    },
                  );
                } else if (state is CartError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              }(),
              bottomNavigationBar: (state is CartLoaded)
                  ? Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Сумма:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${state.cart.totalPrice.toStringAsFixed(2)}₽',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : null,
              // Если корзина не пуста, отображаем кнопку для перехода к оформлению заказа
              floatingActionButton:
                  (state is CartLoaded && state.cart.items.isNotEmpty)
                      ? FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.pushNamed(context, '/order');
                          },
                          label: Text('Оформить заказ'),
                          icon: Icon(Icons.payment),
                        )
                      : null,
            ),
          );
        },
      ),
    );
  }
}
