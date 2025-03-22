part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final Product product;
  final String? selectedVolume; // новый параметр выбора объёма

  const AddProductToCart({
    required this.product,
    this.selectedVolume,
  });

  @override
  List<Object> get props => [product, selectedVolume ?? ''];
}

class RemoveProductFromCart extends CartEvent {
  final Product product;
  final String? selectedVolume;

  const RemoveProductFromCart({
    required this.product,
    this.selectedVolume,
  });

  @override
  List<Object> get props => [product, selectedVolume ?? ''];
}

class UpdateProductInCart extends CartEvent {
  final Product product;
  final int quantity;
  final String? selectedVolume;

  const UpdateProductInCart({
    required this.product,
    required this.quantity,
    this.selectedVolume,
  });

  @override
  List<Object> get props => [product, quantity, selectedVolume ?? ''];
}
