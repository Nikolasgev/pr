import 'package:get_it/get_it.dart';

import 'core/services/telegram_service.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_to_cart.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart';
import 'features/cart/domain/usecases/update_cart_item.dart';
import 'features/cart/presentation/blocs/cart_bloc.dart';
import 'features/catalog/data/repositories/catalog_repository_impl.dart';
import 'features/catalog/domain/usecases/get_products.dart';
import 'features/catalog/presentation/blocs/catalog_bloc.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/domain/usecases/place_order.dart';
import 'features/orders/presentation/blocs/order_bloc.dart';

final sl = GetIt.instance;

void setupInjection() {
  // Регистрация TelegramService как синглтона
  sl.registerLazySingleton<TelegramService>(() => TelegramService());

  // Catalog
  sl.registerLazySingleton<CatalogRepositoryImpl>(
      () => CatalogRepositoryImpl());
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerFactory(() => CatalogBloc(getProducts: sl()));

  // Cart
  sl.registerLazySingleton<CartRepositoryImpl>(() => CartRepositoryImpl());
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItem(sl()));
  sl.registerFactory(() => CartBloc(repository: sl<CartRepositoryImpl>()));

  // Orders
  sl.registerLazySingleton<OrdersRepositoryImpl>(() => OrdersRepositoryImpl());
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerFactory(() => OrderBloc(placeOrder: sl()));
}
