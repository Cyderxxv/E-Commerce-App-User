import '../../../core/domain/product.dart';

abstract class CartEvent {}

class LoadCartData extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final int quantity;
  
  AddToCart(this.product, {this.quantity = 1});
}

class RemoveFromCart extends CartEvent {
  final String cartItemId;
  
  RemoveFromCart(this.cartItemId);
}

class UpdateCartQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;
  
  UpdateCartQuantity(this.cartItemId, this.newQuantity);
}

class ClearCart extends CartEvent {}

// Backward compatibility events
class RemoveFromCartByProductName extends CartEvent {
  final String productName;
  
  RemoveFromCartByProductName(this.productName);
}

class UpdateCartQuantityByProductName extends CartEvent {
  final String productName;
  final int newQuantity;
  
  UpdateCartQuantityByProductName(this.productName, this.newQuantity);
}
