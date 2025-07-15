sealed class WishlistEvent {
  const WishlistEvent();
}

final class LoadWishlistEvent extends WishlistEvent {
  const LoadWishlistEvent();
}

final class AddToWishlistEvent extends WishlistEvent {
  final dynamic product; // Sử dụng dynamic để tránh lỗi import Product
  
  const AddToWishlistEvent({required this.product});
}

final class RemoveFromWishlistEvent extends WishlistEvent {
  final String productId;
  
  const RemoveFromWishlistEvent({required this.productId});
}

final class ClearWishlistEvent extends WishlistEvent {
  const ClearWishlistEvent();
}

final class ToggleWishlistEvent extends WishlistEvent {
  final dynamic product; // Sử dụng dynamic để tránh lỗi import Product
  
  const ToggleWishlistEvent({required this.product});
}
