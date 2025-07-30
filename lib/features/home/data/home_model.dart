import '../../../core/domain/product.dart';
import 'category_model.dart';

/// Result class for home data
class HomeData {
  final List<Product> products;
  final List<Category> categories;

  HomeData({
    required this.products,
    required this.categories,
  });
}