import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/place_order.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PlaceOrder placeOrder;

  OrderBloc({required this.placeOrder}) : super(OrderInitial()) {
    on<PlaceOrderEvent>((event, emit) async {
      emit(OrderPlacing());
      try {
        await placeOrder(event.order);
        emit(OrderPlaced());
      } catch (e) {
        emit(OrderError(message: e.toString()));
      }
    });
  }
}
