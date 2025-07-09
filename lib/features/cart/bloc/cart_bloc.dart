import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:cyder_store/core/domain/product_repo.dart';
import '../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCartData>((event, emit) async {
      final repo = ProductRepository();
      final products = await repo.getProducts();
      final cartItems = products.map((p) => CartItem(product: p, quantity: 1)).toList();
      emit(CartLoaded(cartItems));
    });
  }
}
