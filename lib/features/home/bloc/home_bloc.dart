import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../cores/domain/product_repo.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _productRepository = ProductRepository();
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final products = await _productRepository.getProducts();
      final categories = [
        Category(
          icon: 'smartphone',
          label: 'Phones',
        ),
        Category(
          icon: 'tablet_mac',
          label: 'Tablets',
        ),
        Category(
          icon: 'headphones',
          label: 'Accessories',
        ),
        Category(
          icon: 'laptop_mac',
          label: 'Laptops',
        ),
        // Add more categories as needed
      ];
      emit(HomeLoaded(products: products, categories: categories));
    } catch (e) {
      emit(HomeError(message: 'Failed to load data'));
    }
  }
}