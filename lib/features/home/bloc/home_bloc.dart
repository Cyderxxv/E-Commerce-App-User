import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? HomeRepository(),
        super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final homeData = await _homeRepository.getHomeData();
      emit(HomeLoaded(
        products: homeData.products,
        categories: homeData.categories,
      ));
    } catch (e) {
      emit(HomeError(message: 'Failed to load data'));
    }
  }
}