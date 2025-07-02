import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:cyder_store/cores/domain/product_repo.dart';
import '../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCartData>((event, emit) async {
      print('LoadCartData event received'); // Debug
      final repo = ProductRepository();
      final products = await repo.getProducts();
      print('Products loaded: \\${products.length}'); // Debug
      // Tạo list CartItem từ Product, quantity = 1
      final cartItems = products.map((p) => CartItem(product: p, quantity: 1)).toList();
      print('Emit CartLoaded with items: \\${cartItems.length}'); // Debug
      emit(CartLoaded(cartItems));
    });
  }
}
