import 'package:cyder_store/core/domain/product.dart';

class CartItem {
  final String? id; // Cart item ID from backend
  final Product product;
  int quantity;

  CartItem({
    this.id,
    required this.product, 
    this.quantity = 1,
  });

  /// Create CartItem from API response
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString(),
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'product_id': int.tryParse(product.id) ?? 1,
      'quantity': quantity,
    };
  }
}
