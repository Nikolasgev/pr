import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/core/services/telegram_service.dart';
import 'package:per_shop/core/widgets/custom_action_button_widget.dart';
import 'package:per_shop/core/widgets/custom_snack_bar_widget.dart';
import 'package:per_shop/features/orders/presentation/blocs/order_bloc.dart';
import 'package:per_shop/features/orders/presentation/pages/start_payment.dart';

import '../../../../injection_container.dart';
import '../../../cart/data/repositories/cart_repository_impl.dart';
import '../../../cart/domain/entities/cart.dart';
import '../../domain/entities/order.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  OrderPageState createState() => OrderPageState();
}

class OrderPageState extends State<OrderPage> {
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
            if (state.order.id.isNotEmpty) {
              startPayment(context, state.order.id);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(message: 'Ошибка: пустой ID заказа'),
              );
            }
          }
        },
        child: Builder(
          builder: (context) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Заказ 01'),
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
                              'Сумма заказа',
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
                                      'Цена: ${item.unitPrice.toStringAsFixed(2)}₽  x  ${item.quantity}'),
                                  trailing: Text(
                                      '${(item.totalPrice).toStringAsFixed(2)}₽'),
                                );
                              },
                            ),
                            Divider(),
                            // Итоговая сумма
                            ListTile(
                              title: Text('Сумма'),
                              trailing: Text(
                                '${cart.totalPrice.toStringAsFixed(2)}₽',
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
                                        InputDecoration(labelText: 'ФИО'),
                                    validator: (value) => value!.isEmpty
                                        ? 'Введите своё ФИО'
                                        : null,
                                  ),
                                  TextFormField(
                                    controller: _addressController,
                                    decoration:
                                        InputDecoration(labelText: 'Адрес'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Введите адрес' : null,
                                  ),
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: InputDecoration(
                                        labelText: 'Номер телефона'),
                                    validator: (value) => value!.isEmpty
                                        ? 'Введите номер телефона'
                                        : null,
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration:
                                        InputDecoration(labelText: 'Email'),
                                    validator: (value) =>
                                        value!.isEmpty ? 'Введите email' : null,
                                  ),
                                  TextFormField(
                                    controller: _commentsController,
                                    decoration: InputDecoration(
                                        labelText: 'Комментарий'),
                                  ),
                                  SizedBox(height: 20),
                                  CustomActionButton(
                                    icon: Icons.payment,
                                    label: 'Перейти к оплате',
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final order = Order(
                                          id: generateOrderId(),
                                          clientName:
                                              _clientNameController.text,
                                          address: _addressController.text,
                                          phone: _phoneController.text,
                                          email: _emailController.text,
                                          comments: _commentsController.text,
                                          items: cart.items,
                                          status: 'Pending',
                                          telegramUserId: '',
                                          telegramUsername: '', 
                                          price: cart.totalPrice,
                                        );

                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .set(order.toJson());

                                        context.read<OrderBloc>().add(
                                              PlaceOrderEvent(order: order),
                                            );
                                      }
                                    },
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
              ),
            );
          },
        ),
      ),
    );
  }
}
