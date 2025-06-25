import 'product.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 300));
    return [
      Product(
        imageUrl: 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg',
        name: 'Samsung Galaxy S25 Edge (12/256GB)',
        price: '25.650.600',
        rating: 4.9,
        reviews: 256,
        description: 'Flagship Samsung with stunning display and performance.',
        categories: ['Phones'],
      ),
      Product(
        imageUrl: 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp',
        name: 'Xiaomi 15S PRO (12/256GB)',
        price: '14.550.200',
        rating: 4.8,
        reviews: 128,
        description: 'Affordable powerhouse with premium features.',
        categories: ['Phones'],
      ),
      Product(
        imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-16-pro-2.png',
        name: 'Apple iPhone 16 Pro Max (12/256GB)',
        price: '32.990.000',
        rating: 4.7,
        reviews: 300,
        description: 'Apple’s latest flagship with advanced camera.',
        categories: ['Phones'],
      ),
      Product(
        imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung-galaxy-z-flip-6-xanh-duong-4_2.png',
        name: 'Samsung Galaxy Z Flip6 (12/256GB)',
        price: '20.550.200',
        rating: 4.0,
        reviews: 52,
        description: 'Foldable innovation for the modern user.',
        categories: ['Phones'],
      ),
      Product(
        imageUrl: 'https://thetekcoffee.com/wp-content/uploads/2024/07/galaxy-z-fold6-han-quoc.png',
        name: 'Samsung Galaxy Z Fold6 (12/256GB)',
        price: '30.550.200',
        rating: 4.5,
        reviews: 72,
        description: 'Tablet and phone in one foldable device.',
        categories: ['Phones', 'Tablets'],
      ),
    ];
  }
}
