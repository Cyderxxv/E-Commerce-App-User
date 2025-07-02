import 'package:cyder_store/cores/domain/product.dart';
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
