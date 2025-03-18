import 'package:flutter/material.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Секретный доступ – здесь можно добавить проверку логина/пароля
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Orders'),
      ),
      body: Center(
        child: Text('List of orders will be displayed here.'),
      ),
    );
  }
}
