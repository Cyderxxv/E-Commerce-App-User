import '../../../core/domain/product.dart';
import '../../../core/network/dio_network.dart';
import '../../../core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import '../data/category_model.dart';
import '../data/home_model.dart';

class HomeRepository {
  /// Home page products from backend API
  Future<List<Product>> getProducts({
    int? categoryId,
    bool? featured,
    String? search,
  }) async {
    try {
      // Initialize Dio network
      await DioNetwork.instant.init(AppConstants.baseUrl);
      
      print('🛍️ Fetching products from backend API...');
      
      // Build query parameters
      Map<String, dynamic> queryParams = {};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (featured == true) {
        queryParams['featured'] = 'true';
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      
      final response = await DioNetwork.instant.dio.get(
        '/products',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> productsJson = data['data'] ?? [];
        
        print('✅ Products fetched successfully: ${productsJson.length} items');
        
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch products: ${response.statusCode}');
        return _getMockProducts();
      }
    } catch (e) {
      print('❌ Products fetch error: $e');
      return _getMockProducts();
    }
  }

  /// Get featured products specifically
  Future<List<Product>> getFeaturedProducts() async {
    try {
      await DioNetwork.instant.init(AppConstants.baseUrl);
      
      print('⭐ Fetching featured products...');
      
      final response = await DioNetwork.instant.dio.get(
        '/products/featured',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> productsJson = data['data'] ?? [];
        
        print('✅ Featured products fetched: ${productsJson.length} items');
        
        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch featured products: ${response.statusCode}');
        return _getMockProducts().where((p) => p.isFeatured).toList();
      }
    } catch (e) {
      print('❌ Featured products fetch error: $e');
      return _getMockProducts().where((p) => p.isFeatured).toList();
    }
  }

  /// Fallback mock products
  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'iPhone 15 Pro',
        description: 'Latest iPhone with A17 Pro chip and titanium design',
        price: 999.99,
        imageUrl: 'https://via.placeholder.com/300x300',
        rating: 4.8,
        reviewCount: 120,
        brand: 'Apple',
        isFeatured: true,
        categoryId: '1',
        stock: 50,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24 Ultra',
        description: 'Premium Android phone with S Pen',
        price: 1199.99,
        imageUrl: 'https://via.placeholder.com/300x300',
        rating: 4.7,
        reviewCount: 95,
        brand: 'Samsung',
        isFeatured: true,
        categoryId: '1',
        stock: 40,
      ),
    ];
  }

  /// Home page categories from backend API
  Future<List<Category>> getCategories() async {
    try {
      // Initialize Dio network
      await DioNetwork.instant.init(AppConstants.baseUrl);
      
      print('📁 Fetching categories from backend API...');
      
      final response = await DioNetwork.instant.dio.get(
        '/categories',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> categoriesJson = data['data'] ?? [];
        
        print('✅ Categories fetched successfully: ${categoriesJson.length} items');
        
        return categoriesJson.map((json) => Category.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch categories: ${response.statusCode}');
        return _getMockCategories();
      }
    } catch (e) {
      print('❌ Categories fetch error: $e');
      return _getMockCategories();
    }
  }

  /// Fallback mock categories
  List<Category> _getMockCategories() {
    return [
      Category(
        id: '1',
        name: 'Phones',
        description: 'Latest smartphones and mobile devices',
        imageUrl: 'https://via.placeholder.com/150x150',
        productCount: 50,
        isActive: true,
        icon: 'smartphone',
        label: 'Phones',
      ),
      Category(
        id: '2',
        name: 'Tablets',
        description: 'iPads and Android tablets',
        imageUrl: 'https://via.placeholder.com/150x150',
        productCount: 30,
        isActive: true,
        icon: 'tablet_mac',
        label: 'Tablets',
      ),
      Category(
        id: '3',
        name: 'Laptops',
        description: 'Laptops and computers',
        imageUrl: 'https://via.placeholder.com/150x150',
        productCount: 25,
        isActive: true,
        icon: 'laptop_mac',
        label: 'Laptops',
      ),
      Category(
        id: '4',
        name: 'Smart Watches',
        description: 'Latest smart watch technology',
        imageUrl: 'https://via.placeholder.com/150x150',
        productCount: 15,
        isActive: true,
        icon: 'watch',
        label: 'Smart Watches',
      ),
      Category(
        id: '5',
        name: 'Accessories',
        description: 'Phone and tech accessories',
        imageUrl: 'https://via.placeholder.com/150x150',
        productCount: 40,
        isActive: true,
        icon: 'headphones',
        label: 'Accessories',
      ),
    ];
  }

  /// Get home data (products + categories)
  Future<HomeData> getHomeData() async {
    final products = await getProducts();
    final categories = await getCategories();
    
    return HomeData(
      products: products,
      categories: categories,
    );
  }
}
