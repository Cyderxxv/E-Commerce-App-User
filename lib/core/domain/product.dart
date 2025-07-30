class Product {
  final String id;
  final String imageUrl;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String brand;
  final bool isFeatured;
  final String categoryId;
  final int stock;

  Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.brand,
    required this.isFeatured,
    required this.categoryId,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/300x300',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      brand: json['brand'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      categoryId: json['category_id']?.toString() ?? '1',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'brand': brand,
      'is_featured': isFeatured,
      'category_id': categoryId,
      'stock': stock,
    };
  }
}
