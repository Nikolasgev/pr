import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/features/orders/presentation/blocs/order_bloc.dart';

import '../../../../injection_container.dart';
import '../../../cart/data/repositories/cart_repository_impl.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../domain/entities/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _commentsController = TextEditingController();

  // Функция для генерации случайного 6-значного id заказа
  String generateOrderId() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  // Получаем корзину из репозитория
  Future<Cart> _fetchCart() {
    return sl<CartRepositoryImpl>().getCart();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>(),
      child: BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderPlaced) {
            Navigator.pushReplacementNamed(
              context,
              "/orderSuccessPage",
              arguments: state.order,
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Place Order'),
              ),
              body: FutureBuilder<Cart>(
                future: _fetchCart(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final cart = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Список товаров из корзины
                          Text(
                            'Order Summary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return ListTile(
                                title: Text(item.product.name),
                                subtitle: Text(
                                    'Price: \$${item.product.price.toStringAsFixed(2)}  x  ${item.quantity}'),
                                trailing: Text(
                                    '\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                              );
                            },
                          ),
                          Divider(),
                          // Итоговая сумма
                          ListTile(
                            title: Text('Total'),
                            trailing: Text(
                              '\$${cart.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 20),
                          // Форма для ввода данных клиента
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _clientNameController,
                                  decoration:
                                      InputDecoration(labelText: 'Client Name'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter client name'
                                      : null,
                                ),
                                TextFormField(
                                  controller: _addressController,
                                  decoration:
                                      InputDecoration(labelText: 'Address'),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter address' : null,
                                ),
                                TextFormField(
                                  controller: _phoneController,
                                  decoration:
                                      InputDecoration(labelText: 'Phone'),
                                  validator: (value) => value!.isEmpty
                                      ? 'Enter phone number'
                                      : null,
                                ),
                                TextFormField(
                                  controller: _emailController,
                                  decoration:
                                      InputDecoration(labelText: 'Email'),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Enter email' : null,
                                ),
                                TextFormField(
                                  controller: _commentsController,
                                  decoration:
                                      InputDecoration(labelText: 'Comments'),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final order = Order(
                                        id: generateOrderId(),
                                        clientName: _clientNameController.text,
                                        address: _addressController.text,
                                        phone: _phoneController.text,
                                        email: _emailController.text,
                                        comments: _commentsController.text,
                                        items: cart.items,
                                        status: 'Pending',
                                      );
                                      context.read<OrderBloc>().add(
                                            PlaceOrderEvent(order: order),
                                          );
                                    }
                                  },
                                  child: Text('Submit Order'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
