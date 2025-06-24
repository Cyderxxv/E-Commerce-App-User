class Product {
  final String imageUrl;
  final String name;
  final String price;
  final double rating;
  final int reviews;
  final String description;
  final List<String> categories;

  Product({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.categories,
  });
}
