import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart';
import 'package:per_shop/features/orders/presentation/blocs/admin_orders_bloc.dart';

class AdminOrderDetailPage extends StatefulWidget {
  final Order order;
  const AdminOrderDetailPage({super.key, required this.order});

  @override
  State<AdminOrderDetailPage> createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Детали заказа"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // Оборачиваем в SingleChildScrollView для корректного скроллинга
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID заказа: ${widget.order.id}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Клиент: ${widget.order.clientName}"),
                Text("Адрес: ${widget.order.address}"),
                Text("Телефон: ${widget.order.phone}"),
                Text("Email: ${widget.order.email}"),
                Text("Комментарии: ${widget.order.comments}"),
                Text("telegramUserId: ${widget.order.telegramUserId}"),
                Text("telegramUsername: ${widget.order.telegramUsername}"),
                const SizedBox(height: 16),
                Text("Статус заказа:",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: <String>['Pending', 'Processing', 'Completed']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newStatus) {
                    if (newStatus != null) {
                      setState(() {
                        selectedStatus = newStatus;
                      });
                      // Обновление статуса через Bloc
                      context.read<AdminOrdersBloc>().add(
                            UpdateOrderStatusEvent(
                                orderId: widget.order.id, newStatus: newStatus),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Статус изменён на $newStatus")));
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text("Список товаров:",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                // Отображение списка товаров из заказа
                // Фрагмент из AdminOrderDetailPage, где отображается список товаров заказа:
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.order.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.order.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: Image.network(
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Кол-во: ${item.quantity}'),
                            if (item.selectedVolume != null)
                              Text('Объем: ${item.selectedVolume}'),
                          ],
                        ),
                        trailing: Text(
                          '${(item.product.price * item.quantity).toStringAsFixed(2)}₽',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
                // Если статус "Completed" (Завершен), показываем кнопку удаления
                if (selectedStatus == 'Completed')
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text("Удалить заказ"),
                                content: const Text(
                                    "Вы уверены, что хотите удалить заказ?"),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Отмена")),
                                  TextButton(
                                      onPressed: () {
                                        context.read<AdminOrdersBloc>().add(
                                            DeleteOrderEvent(
                                                orderId: widget.order.id));
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Удалить")),
                                ],
                              ));
                    },
                    child: const Text("Удалить заказ"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
