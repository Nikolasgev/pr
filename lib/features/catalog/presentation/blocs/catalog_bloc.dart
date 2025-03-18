import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final GetProducts getProducts;

  CatalogBloc({required this.getProducts}) : super(CatalogInitial()) {
    on<LoadProducts>((event, emit) async {
      emit(CatalogLoading());
      try {
        final products = await getProducts();
        emit(CatalogLoaded(products: products));
      } catch (e) {
        emit(CatalogError(message: e.toString()));
      }
    });
  }
}
