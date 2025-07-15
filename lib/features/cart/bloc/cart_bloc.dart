import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../domain/cart_repo.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({CartRepository? cartRepository})
      : _cartRepository = cartRepository ?? CartRepository(),
        super(CartInitial()) {
    on<LoadCartData>(_onLoadCartData);
  }

  Future<void> _onLoadCartData(LoadCartData event, Emitter<CartState> emit) async {
    try {
      final cartItems = await _cartRepository.getCartItems();
      emit(CartLoaded(cartItems));
    } catch (e) {
      emit(CartError('Failed to load cart data'));
    }
  }
}
