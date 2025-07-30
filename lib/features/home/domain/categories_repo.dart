import '../../../core/network/dio_network.dart';
import '../../../core/constants/app_constants.dart';

class CategoriesRepository {
  /// Get all categories from backend
  Future<List<Category>> getAllCategories() async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get('/categories');
    
    if (response.statusCode == 200) {
      final List<dynamic> categoriesData = response.data['data'] ?? [];
      return categoriesData.map((json) => Category.fromJson(json)).toList();
    }
    
    throw Exception('Failed to load categories: ${response.statusMessage}');
  }

  /// Get category by ID from backend
  Future<Category?> getCategoryById(String categoryId) async {
    await DioNetwork.instant.init(AppConstants.baseUrl);
    
    final response = await DioNetwork.instant.dio.get('/categories/$categoryId');
    
    if (response.statusCode == 200) {
      return Category.fromJson(response.data['data']);
    }
    
    if (response.statusCode == 404) {
      return null; // Category not found
    }
    
    throw Exception('Failed to load category: ${response.statusMessage}');
  }
}

/// Category model matching backend API structure
class Category {
  final String id;
  final String name;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Category',
      icon: json['icon'] ?? 'category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}

/// Data class for category operation results
class CategoryOperationResult {
  final bool success;
  final String message;
  final List<Category> categories;

  CategoryOperationResult({
    required this.success,
    required this.message,
    required this.categories,
  });
}
