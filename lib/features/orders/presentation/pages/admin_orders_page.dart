import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:per_shop/features/orders/presentation/blocs/admin_orders_bloc.dart';
import 'package:per_shop/injection_container.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrdersBloc(repository: sl<OrdersRepositoryImpl>())
        ..add(LoadOrdersEvent()),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Заказы 011'),
          ),
          body: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
            builder: (context, state) {
              if (state is AdminOrdersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminOrdersLoaded) {
                if (state.orders.isEmpty) {
                  return const Center(child: Text("Нет заказов"));
                }
                return ListView.builder(
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return ListTile(
                      title: Text("Заказ ${order.id} - ${order.clientName}"),
                      subtitle: Text("Статус: ${order.status}"),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/admin/orderDetail',
                          arguments: {
                            'order': order,
                            'adminBloc': context.read<AdminOrdersBloc>(),
                          },
                        );
                      },
                    );
                  },
                );
              } else if (state is AdminOrdersError) {
                return Center(child: Text(state.message));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
