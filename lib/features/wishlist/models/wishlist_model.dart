import '../../../core/domain/product.dart';

class WishlistModel {
  final String id;
  final Product product;
  final DateTime addedAt;

  WishlistModel({
    required this.id,
    required this.product,
    required this.addedAt,
  });
}