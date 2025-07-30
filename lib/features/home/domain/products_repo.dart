import '../../../core/domain/product.dart';
import '../../../core/network/dio_network.dart';
import '../../../core/constants/app_constants.dart';

class ProductsRepository {
  /// Get all products from backend
  Future<List<Product>> getAllProducts() async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get('/products');
    
    if (response.statusCode == 200) {
      final List<dynamic> productsData = response.data['data'] ?? [];
      return productsData.map((json) => Product.fromJson(json)).toList();
    }
    
    throw Exception('Failed to load products: ${response.statusMessage}');
  }

  /// Get featured products from backend
  Future<List<Product>> getFeaturedProducts() async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get('/products/featured');
    
    if (response.statusCode == 200) {
      final List<dynamic> productsData = response.data['data'] ?? [];
      return productsData.map((json) => Product.fromJson(json)).toList();
    }
    
    throw Exception('Failed to load featured products: ${response.statusMessage}');
  }

  /// Get products by category from backend
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get(
      '/products',
      queryParameters: {'category_id': int.tryParse(categoryId) ?? 1},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> productsData = response.data['data'] ?? [];
      return productsData.map((json) => Product.fromJson(json)).toList();
    }
    
    throw Exception('Failed to load products by category: ${response.statusMessage}');
  }

  /// Search products from backend
  Future<List<Product>> searchProducts(String query) async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> productsData = response.data['data'] ?? [];
      return productsData.map((json) => Product.fromJson(json)).toList();
    }
    
    throw Exception('Failed to search products: ${response.statusMessage}');
  }

  /// Get product by ID from backend
  Future<Product?> getProductById(String productId) async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get('/products/$productId');
    
    if (response.statusCode == 200) {
      return Product.fromJson(response.data['data']);
    }
    
    if (response.statusCode == 404) {
      return null; // Product not found
    }
    
    throw Exception('Failed to load product: ${response.statusMessage}');
  }
}

/// Data class for product operation results
class ProductOperationResult {
  final bool success;
  final String message;
  final List<Product> products;

  ProductOperationResult({
    required this.success,
    required this.message,
    required this.products,
  });
}
