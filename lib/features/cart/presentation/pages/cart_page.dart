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
          return Scaffold(
            appBar: AppBar(
              title: Text('Cart'),
            ),
            body: () {
              if (state is CartLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded) {
                if (state.cart.items.isEmpty) {
                  return Center(child: Text('Cart is empty'));
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
          );
        },
      ),
    );
  }
}
