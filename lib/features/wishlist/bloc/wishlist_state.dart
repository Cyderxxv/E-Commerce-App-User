import '../models/wishlist_model.dart';

sealed class WishlistState {
  const WishlistState();
}

final class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

final class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

final class WishlistLoaded extends WishlistState {
  final List<WishlistModel> items;
  
  const WishlistLoaded({required this.items});
  
  bool get isEmpty => items.isEmpty;
  int get itemCount => items.length;
  
  bool isProductInWishlist(String productId) {
    return items.any((item) => item.product.name == productId);
  }
  
  WishlistModel? getWishlistItem(String productId) {
    try {
      return items.firstWhere((item) => item.product.name == productId);
    } catch (e) {
      return null;
    }
  }
}

final class WishlistError extends WishlistState {
  final String message;
  final String? errorCode;
  
  const WishlistError({
    required this.message,
    this.errorCode,
  });
}

final class WishlistActionInProgress extends WishlistState {
  final List<WishlistModel> items;
  final String actionType;
  final String? targetProductId;
  
  const WishlistActionInProgress({
    required this.items,
    required this.actionType,
    this.targetProductId,
  });
}
