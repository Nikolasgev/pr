import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/order.dart';
import '../blocs/order_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderBloc>(),
      child: Builder(
        builder: (context) {
          // Новый контекст, являющийся потомком BlocProvider
          return Scaffold(
            appBar: AppBar(
              title: Text('Place Order'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocListener<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderPlaced) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order placed successfully')),
                    );
                  } else if (state is OrderError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _clientNameController,
                        decoration: InputDecoration(labelText: 'Client Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter client name' : null,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter address' : null,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Phone'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter phone number' : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) =>
                            value!.isEmpty ? 'Enter email' : null,
                      ),
                      TextFormField(
                        controller: _commentsController,
                        decoration: InputDecoration(labelText: 'Comments'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final order = Order(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              clientName: _clientNameController.text,
                              address: _addressController.text,
                              phone: _phoneController.text,
                              email: _emailController.text,
                              comments: _commentsController.text,
                              products: [], // Для примера передаём пустой список товаров
                              status: 'Pending',
                            );
                            // Используем контекст из Builder – он гарантированно ниже BlocProvider
                            context
                                .read<OrderBloc>()
                                .add(PlaceOrderEvent(order: order));
                          }
                        },
                        child: Text('Submit Order'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
