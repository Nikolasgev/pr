import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:per_shop/features/orders/presentation/blocs/admin_orders_bloc.dart';
import 'package:per_shop/features/orders/presentation/pages/admin_order_detail_page.dart';
import 'package:per_shop/injection_container.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrdersBloc(repository: sl<OrdersRepositoryImpl>())
        ..add(LoadOrdersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Orders'),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AdminOrderDetailPage(order: order)),
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
    );
  }
}
