class Category {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int productCount;
  final bool isActive;
  final String? icon; // Keep for UI compatibility
  final String? label; // Keep for UI compatibility

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.productCount,
    required this.isActive,
    this.icon,
    this.label,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown Category',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150x150',
      productCount: json['product_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      icon: json['icon'],
      label: json['name'] ?? 'Unknown Category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'product_count': productCount,
      'is_active': isActive,
      'icon': icon,
    };
  }
}