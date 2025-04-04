import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:per_shop/features/catalog/domain/entities/product.dart';
import 'package:per_shop/features/catalog/presentation/pages/product_detail_page.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart';
import 'package:per_shop/features/orders/presentation/blocs/admin_orders_bloc.dart';
import 'package:per_shop/features/orders/presentation/pages/admin_order_detail_page.dart';
import 'package:per_shop/features/orders/presentation/pages/order_success_page.dart';

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
      case '/orderSuccessPage':
        final order = settings.arguments as Order;
        return MaterialPageRoute(
            builder: (_) => OrderSuccessPage(
                  order: order,
                ));
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminOrdersPage());
      case '/admin/orderDetail':
        final args = settings.arguments as Map<String, dynamic>;
        final order = args['order'] as Order;
        final adminBloc = args['adminBloc'] as AdminOrdersBloc;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: adminBloc,
            child: AdminOrderDetailPage(order: order),
          ),
        );
      case '/product':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product));
      default:
        return MaterialPageRoute(builder: (_) => CatalogPage());
    }
  }
}
