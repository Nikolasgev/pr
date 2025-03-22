import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:per_shop/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:per_shop/features/orders/domain/entities/order.dart';

part 'admin_orders_event.dart';
part 'admin_orders_state.dart';

class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final OrdersRepositoryImpl repository;
  AdminOrdersBloc({required this.repository}) : super(AdminOrdersInitial()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(AdminOrdersLoading());
      try {
        final orders = await repository.getOrders();
        emit(AdminOrdersLoaded(orders: orders));
      } catch (e) {
        emit(AdminOrdersError(message: e.toString()));
      }
    });
    on<UpdateOrderStatusEvent>((event, emit) async {
      try {
        await repository.updateOrderStatus(event.orderId, event.newStatus);
        add(LoadOrdersEvent());
      } catch (e) {
        emit(AdminOrdersError(message: e.toString()));
      }
    });
    on<DeleteOrderEvent>((event, emit) async {
      try {
        await repository.deleteOrder(event.orderId);
        add(LoadOrdersEvent());
      } catch (e) {
        emit(AdminOrdersError(message: e.toString()));
      }
    });
  }
}
