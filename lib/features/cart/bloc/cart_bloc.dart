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
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartQuantity>(_onUpdateCartQuantity);
    on<ClearCart>(_onClearCart);
    on<RemoveFromCartByProductName>(_onRemoveFromCartByProductName);
    on<UpdateCartQuantityByProductName>(_onUpdateCartQuantityByProductName);
  }

  Future<void> _onLoadCartData(LoadCartData event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cartItems = await _cartRepository.getCartItems();
      final total = await _cartRepository.getCartTotal();
      final itemsCount = await _cartRepository.getCartItemsCount();
      
      emit(CartLoaded(cartItems, total: total, itemsCount: itemsCount));
    } catch (e) {
      emit(CartError('Failed to load cart data: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.addToCart(event.product, quantity: event.quantity);
      
      if (result.success) {
        final total = await _cartRepository.getCartTotal();
        final itemsCount = await _cartRepository.getCartItemsCount();
        
        emit(CartOperationSuccess(
          result.message, 
          result.cartItems,
          total: total,
          itemsCount: itemsCount,
        ));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.removeFromCart(event.cartItemId);
      
      if (result.success) {
        final total = await _cartRepository.getCartTotal();
        final itemsCount = await _cartRepository.getCartItemsCount();
        
        emit(CartOperationSuccess(
          result.message, 
          result.cartItems,
          total: total,
          itemsCount: itemsCount,
        ));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to remove item from cart: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartQuantity(UpdateCartQuantity event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.updateQuantity(event.cartItemId, event.newQuantity);
      
      if (result.success) {
        final total = await _cartRepository.getCartTotal();
        final itemsCount = await _cartRepository.getCartItemsCount();
        
        emit(CartOperationSuccess(
          result.message, 
          result.cartItems,
          total: total,
          itemsCount: itemsCount,
        ));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.clearCart();
      
      if (result.success) {
        emit(CartOperationSuccess(result.message, result.cartItems));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }

  // Backward compatibility methods
  Future<void> _onRemoveFromCartByProductName(RemoveFromCartByProductName event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.removeFromCartByProductName(event.productName);
      
      if (result.success) {
        final total = await _cartRepository.getCartTotal();
        final itemsCount = await _cartRepository.getCartItemsCount();
        
        emit(CartOperationSuccess(
          result.message, 
          result.cartItems,
          total: total,
          itemsCount: itemsCount,
        ));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to remove item: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCartQuantityByProductName(UpdateCartQuantityByProductName event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final result = await _cartRepository.updateQuantityByProductName(event.productName, event.newQuantity);
      
      if (result.success) {
        final total = await _cartRepository.getCartTotal();
        final itemsCount = await _cartRepository.getCartItemsCount();
        
        emit(CartOperationSuccess(
          result.message, 
          result.cartItems,
          total: total,
          itemsCount: itemsCount,
        ));
      } else {
        emit(CartError(result.message, cartItems: result.cartItems));
      }
    } catch (e) {
      emit(CartError('Failed to update quantity: ${e.toString()}'));
    }
  }
}
