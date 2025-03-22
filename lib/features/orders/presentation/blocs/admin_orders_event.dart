part of 'admin_orders_bloc.dart';

abstract class AdminOrdersEvent extends Equatable {
  const AdminOrdersEvent();
  @override
  List<Object> get props => [];
}

class LoadOrdersEvent extends AdminOrdersEvent {}

class UpdateOrderStatusEvent extends AdminOrdersEvent {
  final String orderId;
  final String newStatus;
  const UpdateOrderStatusEvent(
      {required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [orderId, newStatus];
}

class DeleteOrderEvent extends AdminOrdersEvent {
  final String orderId;
  const DeleteOrderEvent({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
