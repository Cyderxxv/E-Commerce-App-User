import '../models/wishlist_model.dart';
import '../../../core/domain/product.dart';

class WishlistRepository {
  // In-memory storage for demo
  final List<WishlistModel> _wishlistItems = [];

  /// Get all wishlist items
  Future<List<WishlistModel>> getWishlistItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_wishlistItems);
  }

  /// Add product to wishlist
  Future<WishlistOperationResult> addToWishlist(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // Check if product already exists
      final existingIndex = _wishlistItems.indexWhere(
        (item) => item.product.name == product.name,
      );
      
      if (existingIndex != -1) {
        return WishlistOperationResult(
          success: false,
          message: 'Product already exists in wishlist',
          items: List.from(_wishlistItems),
        );
      }
      
      // Add new item
      final newItem = WishlistModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        addedAt: DateTime.now(),
      );
      
      _wishlistItems.add(newItem);
      
      return WishlistOperationResult(
        success: true,
        message: 'Product added to wishlist successfully',
        items: List.from(_wishlistItems),
      );
    } catch (e) {
      return WishlistOperationResult(
        success: false,
        message: 'Failed to add product to wishlist',
        items: List.from(_wishlistItems),
      );
    }
  }

  /// Remove product from wishlist
  Future<WishlistOperationResult> removeFromWishlist(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final initialLength = _wishlistItems.length;
      _wishlistItems.removeWhere(
        (item) => item.id == productId,
      );
      final finalLength = _wishlistItems.length;
      final removedCount = initialLength - finalLength;
      
      if (removedCount > 0) {
        return WishlistOperationResult(
          success: true,
          message: 'Product removed from wishlist successfully',
          items: List.from(_wishlistItems),
        );
      } else {
        return WishlistOperationResult(
          success: false,
          message: 'Product not found in wishlist',
          items: List.from(_wishlistItems),
        );
      }
    } catch (e) {
      return WishlistOperationResult(
        success: false,
        message: 'Failed to remove product from wishlist',
        items: List.from(_wishlistItems),
      );
    }
  }

  /// Clear all wishlist items
  Future<WishlistOperationResult> clearWishlist() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      _wishlistItems.clear();
      
      return WishlistOperationResult(
        success: true,
        message: 'Wishlist cleared successfully',
        items: [],
      );
    } catch (e) {
      return WishlistOperationResult(
        success: false,
        message: 'Failed to clear wishlist',
        items: List.from(_wishlistItems),
      );
    }
  }

  /// Toggle product in wishlist (add if not exists, remove if exists)
  Future<WishlistOperationResult> toggleWishlist(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final existingIndex = _wishlistItems.indexWhere(
        (item) => item.product.name == product.name,
      );
      
      if (existingIndex != -1) {
        // Remove if exists
        _wishlistItems.removeAt(existingIndex);
        return WishlistOperationResult(
          success: true,
          message: 'Product removed from wishlist',
          items: List.from(_wishlistItems),
        );
      } else {
        // Add if not exists
        final newItem = WishlistModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          addedAt: DateTime.now(),
        );
        
        _wishlistItems.add(newItem);
        
        return WishlistOperationResult(
          success: true,
          message: 'Product added to wishlist',
          items: List.from(_wishlistItems),
        );
      }
    } catch (e) {
      return WishlistOperationResult(
        success: false,
        message: 'Failed to toggle wishlist',
        items: List.from(_wishlistItems),
      );
    }
  }

  /// Check if product is in wishlist
  Future<bool> isInWishlist(String productName) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    return _wishlistItems.any(
      (item) => item.product.name == productName,
    );
  }

  /// Get wishlist count
  Future<int> getWishlistCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _wishlistItems.length;
  }
}

/// Result class for wishlist operations
class WishlistOperationResult {
  final bool success;
  final String message;
  final List<WishlistModel> items;

  WishlistOperationResult({
    required this.success,
    required this.message,
    required this.items,
  });
}
