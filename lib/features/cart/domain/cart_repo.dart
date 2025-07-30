import '../models/cart_item.dart';
import '../../../core/domain/product.dart';

class CartRepository {
  // In-memory cart storage for demo
  final List<CartItem> _cartItems = [];

  /// Get all items in cart
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // If cart is empty, add some demo items
    if (_cartItems.isEmpty) {
      _cartItems.addAll([
        CartItem(
          product: Product(
            id: '1',
            imageUrl: 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg',
            name: 'Samsung Galaxy S25 Edge (12/256GB)',
            price: 25650600.0,
            rating: 4.9,
            reviewCount: 256,
            description: 'Flagship Samsung with stunning display and performance.',
            brand: 'Samsung',
            isFeatured: true,
            categoryId: '1',
            stock: 10,
          ),
          quantity: 1,
        ),
        CartItem(
          product: Product(
            id: '2',
            imageUrl: 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp',
            name: 'Xiaomi 15S PRO (12/256GB)',
            price: 14550200.0,
            rating: 4.8,
            reviewCount: 128,
            description: 'Affordable powerhouse with premium features.',
            brand: 'Xiaomi',
            isFeatured: true,
            categoryId: '1',
            stock: 15,
          ),
          quantity: 2,
        ),
      ]);
    }
    
    return List.from(_cartItems);
  }

  /// Add item to cart
  Future<CartOperationResult> addToCart(Product product, {int quantity = 1}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      // Check if item already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.name == product.name,
      );
      
      if (existingIndex != -1) {
        // Update quantity if item already exists
        _cartItems[existingIndex].quantity += quantity;
      } else {
        // Add new item
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }
      
      return CartOperationResult(
        success: true,
        message: 'Item added to cart successfully',
        cartItems: List.from(_cartItems),
      );
    } catch (e) {
      return CartOperationResult(
        success: false,
        message: 'Failed to add item to cart',
        cartItems: List.from(_cartItems),
      );
    }
  }

  /// Remove item from cart
  Future<CartOperationResult> removeFromCart(String productName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      _cartItems.removeWhere((item) => item.product.name == productName);
      
      return CartOperationResult(
        success: true,
        message: 'Item removed from cart successfully',
        cartItems: List.from(_cartItems),
      );
    } catch (e) {
      return CartOperationResult(
        success: false,
        message: 'Failed to remove item from cart',
        cartItems: List.from(_cartItems),
      );
    }
  }

  /// Update item quantity
  Future<CartOperationResult> updateQuantity(String productName, int newQuantity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      if (newQuantity <= 0) {
        return removeFromCart(productName);
      }
      
      final itemIndex = _cartItems.indexWhere(
        (item) => item.product.name == productName,
      );
      
      if (itemIndex != -1) {
        _cartItems[itemIndex].quantity = newQuantity;
        
        return CartOperationResult(
          success: true,
          message: 'Quantity updated successfully',
          cartItems: List.from(_cartItems),
        );
      } else {
        return CartOperationResult(
          success: false,
          message: 'Item not found in cart',
          cartItems: List.from(_cartItems),
        );
      }
    } catch (e) {
      return CartOperationResult(
        success: false,
        message: 'Failed to update quantity',
        cartItems: List.from(_cartItems),
      );
    }
  }

  /// Clear all items from cart
  Future<CartOperationResult> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      _cartItems.clear();
      
      return CartOperationResult(
        success: true,
        message: 'Cart cleared successfully',
        cartItems: [],
      );
    } catch (e) {
      return CartOperationResult(
        success: false,
        message: 'Failed to clear cart',
        cartItems: List.from(_cartItems),
      );
    }
  }

  /// Get cart total amount
  Future<double> getCartTotal() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    double total = 0;
    for (final item in _cartItems) {
      total += item.product.price * item.quantity;
    }
    
    return total;
  }

  /// Get cart items count
  Future<int> getCartItemsCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}

/// Result class for cart operations
class CartOperationResult {
  final bool success;
  final String message;
  final List<CartItem> cartItems;

  CartOperationResult({
    required this.success,
    required this.message,
    required this.cartItems,
  });
}
