import 'package:flutter/material.dart';
import 'package:per_shop/features/catalog/domain/entities/product.dart';
import 'package:per_shop/features/catalog/presentation/pages/product_detail_page.dart';

import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/orders/presentation/pages/admin_orders_page.dart';
import '../../features/orders/presentation/pages/order_page.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    // Маршруты приложения с использованием Octopus (для простоты – стандартный MaterialPageRoute)
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => CatalogPage());
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartPage());
      case '/order':
        return MaterialPageRoute(builder: (_) => OrderPage());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminOrdersPage());
      case '/product':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
