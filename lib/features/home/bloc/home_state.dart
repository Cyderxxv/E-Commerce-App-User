import '../../../core/domain/product.dart';
import '../domain/home_repo.dart';

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