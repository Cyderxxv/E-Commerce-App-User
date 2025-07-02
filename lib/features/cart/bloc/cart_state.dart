import 'package:cyder_store/cores/domain/product.dart';
import 'package:cyder_store/features/cart/models/cart_item.dart';

abstract class CartState {}
class CartInitial extends CartState {}
class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  CartLoaded(this.cartItems);
}
