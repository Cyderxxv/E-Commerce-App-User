import '../../../cores/domain/product.dart';

// Category model
class Category {
  final String icon;
  final String label;

  Category({
    required this.icon,
    required this.label,
  });
}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> products;
  final List<Category> categories;

  HomeLoaded({required this.products, required this.categories});
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}
