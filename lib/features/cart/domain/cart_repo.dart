import '../models/cart_item.dart';
import '../../../core/domain/product.dart';
import '../../../core/network/dio_network.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/domain/auth_repo.dart';
import 'package:dio/dio.dart';

class CartRepository {
  /// Get current user ID from AuthRepository
  String? _getCurrentUserId() {
    final currentUser = AuthRepository.instance.getCurrentUserSync();
    return currentUser?.userId;
  }


  /// Check if user can access cart (without throwing exception)
  bool _canAccessCart() {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Get all items in cart from backend
  Future<List<CartItem>> getCartItems() async {
    // Quick check before making API call
    if (!_canAccessCart()) {
      print('🔓 Cart: User not authenticated, returning empty cart');
      return [];
    }
    
    try {
      final userId = _getCurrentUserId()!;
      
      await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
      
      final response = await DioNetwork.instant.dio.get(
        '/cart',
        queryParameters: {'user_id': userId},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final List<dynamic> items = data['items'] ?? [];
        
        return items.map((item) {
          return CartItem(
            id: item['id'].toString(),
            product: Product.fromJson(item['product']),
            quantity: item['quantity'],
          );
        }).toList();
      }
      
      throw Exception('Failed to load cart items: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔓 Cart: Received 401 Unauthorized - user needs to login');
        // Clear the auth state since token is invalid
        await AuthRepository.instance.logout();
        return [];
      }
      throw Exception('Failed to load cart items: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Authentication token not found') || 
          e.toString().contains('User not logged in')) {
        // Return empty list for unauthenticated users
        return [];
      }
      throw e;
    }
  }

  /// Add item to cart via backend API
  Future<CartOperationResult> addToCart(Product product, {int quantity = 1}) async {
    // Quick check before making API call
    if (!_canAccessCart()) {
      print('🔓 Cart: User not authenticated, cannot add to cart');
      return CartOperationResult(
        success: false,
        message: 'Please login to add items to cart',
        cartItems: [],
      );
    }
    
    try {
      final userId = _getCurrentUserId()!;
      
      await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
      
      final response = await DioNetwork.instant.dio.post(
        '/cart',
        queryParameters: {'user_id': userId},
        data: {
          'product_id': int.tryParse(product.id) ?? 1,
          'quantity': quantity,
        },
      );
      
      if (response.statusCode == 201) {
        // Get updated cart items
        final cartItems = await getCartItems();
        return CartOperationResult(
          success: true,
          message: response.data['message'] ?? 'Item added to cart successfully',
          cartItems: cartItems,
        );
      }
      
      throw Exception('Failed to add item to cart: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔓 Cart: Received 401 Unauthorized - user needs to login');
        // Clear the auth state since token is invalid
        await AuthRepository.instance.logout();
        return CartOperationResult(
          success: false,
          message: 'Please login to add items to cart',
          cartItems: [],
        );
      }
      return CartOperationResult(
        success: false,
        message: 'Failed to add item to cart: ${e.message}',
        cartItems: [],
      );
    } catch (e) {
      if (e.toString().contains('Authentication token not found') || 
          e.toString().contains('User not logged in')) {
        return CartOperationResult(
          success: false,
          message: 'Please login to add items to cart',
          cartItems: [],
        );
      }
      throw e;
    }
  }

  /// Remove item from cart via backend API
  Future<CartOperationResult> removeFromCart(String cartItemId) async {
    try {
      final userId = _getCurrentUserId()!;
      
      await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
      
      final response = await DioNetwork.instant.dio.delete(
        '/cart/$cartItemId',
        queryParameters: {'user_id': userId},
      );
      
      if (response.statusCode == 200) {
        final cartItems = await getCartItems();
        return CartOperationResult(
          success: true,
          message: response.data['message'] ?? 'Item removed from cart successfully',
          cartItems: cartItems,
        );
      }
      
      throw Exception('Failed to remove item from cart: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔓 Cart: Received 401 Unauthorized - user needs to login');
        await AuthRepository.instance.logout();
        return CartOperationResult(
          success: false,
          message: 'Please login to remove items from cart',
          cartItems: [],
        );
      }
      return CartOperationResult(
        success: false,
        message: 'Failed to remove item from cart: ${e.message}',
        cartItems: [],
      );
    } catch (e) {
      throw Exception('Failed to remove item from cart: ${e.toString()}');
    }
  }

  /// Update item quantity via backend API
  Future<CartOperationResult> updateQuantity(String cartItemId, int newQuantity) async {
    final userId = _getCurrentUserId()!;
    
    if (newQuantity <= 0) {
      return removeFromCart(cartItemId);
    }
    
    await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
    
    final response = await DioNetwork.instant.dio.put(
      '/cart/$cartItemId',
      queryParameters: {'user_id': userId},
      data: {
        'quantity': newQuantity,
      },
    );
    
    if (response.statusCode == 200) {
      final cartItems = await getCartItems();
      return CartOperationResult(
        success: true,
        message: response.data['message'] ?? 'Quantity updated successfully',
        cartItems: cartItems,
      );
    }
    
    throw Exception('Failed to update quantity: ${response.statusMessage}');
  }

  /// Clear all items from cart via backend API
  Future<CartOperationResult> clearCart() async {;
    final userId = _getCurrentUserId()!;
    
    await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
    
    final response = await DioNetwork.instant.dio.delete(
      '/cart',
      queryParameters: {'user_id': userId},
    );
    
    if (response.statusCode == 200) {
      return CartOperationResult(
        success: true,
        message: response.data['message'] ?? 'Cart cleared successfully',
        cartItems: [],
      );
    }
    
    throw Exception('Failed to clear cart: ${response.statusMessage}');
  }

  /// Get cart total amount from backend
  Future<double> getCartTotal() async {
    try {
      final userId = _getCurrentUserId()!;
      
      await DioNetwork.instant.init(AppConstants.baseUrl, isAuth: true);
      
      final response = await DioNetwork.instant.dio.get(
        '/cart',
        queryParameters: {'user_id': userId},
      );
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return (data['total'] ?? 0.0).toDouble();
      }
      
      throw Exception('Failed to get cart total: ${response.statusMessage}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print('🔓 Cart: Received 401 Unauthorized - user needs to login');
        await AuthRepository.instance.logout();
        return 0.0;
      }
      throw Exception('Failed to get cart total: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Authentication token not found') || 
          e.toString().contains('User not logged in')) {
        return 0.0;
      }
      throw e;
    }
  }

  /// Get cart items count
  Future<int> getCartItemsCount() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  // Helper methods for backward compatibility

  /// Remove item by product name (for backward compatibility)
  Future<CartOperationResult> removeFromCartByProductName(String productName) async {
    final cartItems = await getCartItems();
    final cartItem = cartItems.firstWhere(
      (item) => item.product.name == productName,
      orElse: () => throw Exception('Product not found in cart'),
    );
    
    if (cartItem.id != null) {
      return removeFromCart(cartItem.id!);
    }
    
    throw Exception('Cart item ID not found');
  }

  /// Update quantity by product name (for backward compatibility)
  Future<CartOperationResult> updateQuantityByProductName(String productName, int newQuantity) async {
    final cartItems = await getCartItems();
    final cartItem = cartItems.firstWhere(
      (item) => item.product.name == productName,
      orElse: () => throw Exception('Product not found in cart'),
    );
    
    if (cartItem.id != null) {
      return updateQuantity(cartItem.id!, newQuantity);
    }
    
    throw Exception('Cart item ID not found');
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
