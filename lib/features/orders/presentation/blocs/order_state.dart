part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderPlacing extends OrderState {}

class OrderPlaced extends OrderState {}

class OrderError extends OrderState {
  final String message;
  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
