import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart' as order;


class OrderSuccessPageFromId extends StatefulWidget {
  final String orderId;

  const OrderSuccessPageFromId({super.key, required this.orderId});

  @override
  State<OrderSuccessPageFromId> createState() => _OrderSuccessPageFromIdState();
}

class _OrderSuccessPageFromIdState extends State<OrderSuccessPageFromId> {
  order.Order? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final doc = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _order = order.Order.fromJson(data); // важно, чтобы Order имел fromJson
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_order == null) {
      return const Scaffold(body: Center(child: Text('Заказ не найден')));
    }
    return OrderSuccessPageFromId(orderId: _order!.id);
  }
}
