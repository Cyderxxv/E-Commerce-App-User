import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/wishlist_repo.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc({WishlistRepository? wishlistRepository})
      : _wishlistRepository = wishlistRepository ?? WishlistRepository(),
        super(const WishlistInitial()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
    on<ClearWishlistEvent>(_onClearWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(const WishlistLoading());
    
    try {
      final items = await _wishlistRepository.getWishlistItems();
      emit(WishlistLoaded(items: items));
    } catch (error) {
      emit(WishlistError(
        message: 'Failed to load wishlist: ${error.toString()}',
        errorCode: 'LOAD_ERROR',
      ));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final result = await _wishlistRepository.addToWishlist(event.product);
      
      if (result.success) {
        emit(WishlistLoaded(items: result.items));
      } else {
        emit(WishlistError(
          message: result.message,
          errorCode: 'ADD_ERROR',
        ));
      }
    } catch (error) {
      emit(WishlistError(
        message: 'Failed to add to wishlist: ${error.toString()}',
        errorCode: 'ADD_ERROR',
      ));
    }
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final result = await _wishlistRepository.removeFromWishlist(event.productId);
      
      if (result.success) {
        emit(WishlistLoaded(items: result.items));
      } else {
        emit(WishlistError(
          message: result.message,
          errorCode: 'REMOVE_ERROR',
        ));
      }
    } catch (error) {
      emit(WishlistError(
        message: 'Failed to remove from wishlist: ${error.toString()}',
        errorCode: 'REMOVE_ERROR',
      ));
    }
  }

  Future<void> _onClearWishlist(
    ClearWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final result = await _wishlistRepository.clearWishlist();
      
      if (result.success) {
        emit(WishlistLoaded(items: result.items));
      } else {
        emit(WishlistError(
          message: result.message,
          errorCode: 'CLEAR_ERROR',
        ));
      }
    } catch (error) {
      emit(WishlistError(
        message: 'Failed to clear wishlist: ${error.toString()}',
        errorCode: 'CLEAR_ERROR',
      ));
    }
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final result = await _wishlistRepository.toggleWishlist(event.product);
      
      if (result.success) {
        emit(WishlistLoaded(items: result.items));
      } else {
        emit(WishlistError(
          message: result.message,
          errorCode: 'TOGGLE_ERROR',
        ));
      }
    } catch (error) {
      emit(WishlistError(
        message: 'Failed to toggle wishlist: ${error.toString()}',
        errorCode: 'TOGGLE_ERROR',
      ));
    }
  }
}
