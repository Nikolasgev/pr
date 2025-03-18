import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepositoryImpl repository = CartRepositoryImpl();

  CartBloc() : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      emit(CartLoading());
      try {
        final cart = await repository.getCart();
        emit(CartLoaded(cart: cart));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });

    on<AddProductToCart>((event, emit) async {
      await repository.addProduct(event.product);
      final cart = await repository.getCart();
      emit(CartLoaded(cart: cart));
    });

    on<RemoveProductFromCart>((event, emit) async {
      await repository.removeProduct(event.product);
      final cart = await repository.getCart();
      emit(CartLoaded(cart: cart));
    });

    on<UpdateProductInCart>((event, emit) async {
      await repository.updateProduct(event.product, event.quantity);
      final cart = await repository.getCart();
      emit(CartLoaded(cart: cart));
    });
  }
}
