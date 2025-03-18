part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;
  const AddProductToCart({required this.product});

  @override
  List<Object> get props => [product];
}

class RemoveProductFromCart extends CartEvent {
  final Product product;
  const RemoveProductFromCart({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProductInCart extends CartEvent {
  final Product product;
  final int quantity;
  const UpdateProductInCart({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
