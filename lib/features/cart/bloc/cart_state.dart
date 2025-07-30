import 'package:cyder_store/features/cart/models/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final double total;
  final int itemsCount;
  
  CartLoaded(this.cartItems, {this.total = 0.0, this.itemsCount = 0});
}

class CartError extends CartState {
  final String message;
  final List<CartItem> cartItems;
  
  CartError(this.message, {this.cartItems = const []});
}

class CartOperationSuccess extends CartState {
  final String message;
  final List<CartItem> cartItems;
  final double total;
  final int itemsCount;
  
  CartOperationSuccess(
    this.message, 
    this.cartItems, {
    this.total = 0.0, 
    this.itemsCount = 0,
  });
}
