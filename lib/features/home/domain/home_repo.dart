import '../../../core/domain/product.dart';

class Category {
  final String icon;
  final String label;

  Category({
    required this.icon,
    required this.label,
  });
}

class HomeRepository {
  /// Home page product
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      // Phones
      Product(
        imageUrl: 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg',
        name: 'Samsung Galaxy S25 Edge (12/256GB)',
        price: '25.650.600',
        rating: 4.9,
        reviews: 256,
        description: 'Samsung flagship with curved-edge design and powerful performance.\n'
                      'Display: 6.8" Dynamic AMOLED 2X, QHD+, 144Hz\n'
                      'CPU: Snapdragon 8 Gen 3\n'
                      'RAM: 12GB\n'
                      'Storage: 256GB UFS 4.0\n'
                      'Rear Camera: 200MP + 50MP (Tele) + 12MP (Ultra-wide)\n'
                      'Front Camera: 32MP\n'
                      'Battery: 5000mAh, 65W fast charging\n'
                      'OS: One UI 7 (Android 15)\n'
                      'Water & Dust Resistance: IP68\n'
                      'Security: Ultrasonic fingerprint, Face unlock',
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
        description: 'Apple\'s latest flagship with advanced camera.',
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
      
      // Laptops
      Product(
        imageUrl: 'https://bizweb.dktcdn.net/100/453/356/products/mbair-13inch-m4-midnight-1744562440665.jpg?v=1747827209317',
        name: 'Apple MacBook Air M4 13-inch (16/512GB)',
        price: '29.990.000',
        rating: 4.8,
        reviews: 180,
        description: 'Sleek and powerful laptop with Apple\'s latest M4 chip.\n'
                      'Display: 13.6" Liquid Retina, 2560x1664\n'
                      'CPU: Apple M4 10-core\n'
                      'RAM: 16GB\n'
                      'Storage: 512GB SSD\n'
                      'Battery: Up to 18 hours\n'
                      'OS: macOS Tahoe\n'
                      'Weight: 1.24kg\n'
                      'Ports: 2x Thunderbolt 4, MagSafe 3',
        categories: ['Laptops'],
      ),
      Product(
        imageUrl: 'https://sazo.vn/storage/products/zenbook-s14/4.png',
        name: 'Asus Zenbook S 14 (16/1TB)',
        price: '35.990.000',
        rating: 4.7,
        reviews: 95,
        description: 'Premium ultrabook with stunning OLED display.\n'
                      'Display: 14" 3K OLED, 120Hz\n'
                      'CPU: Intel Core Ultra 7 155H\n'
                      'RAM: 16GB LPDDR5X\n'
                      'Storage: 1TB SSD\n'
                      'Battery: Up to 17 hours\n'
                      'OS: Windows 11 Home\n'
                      'Weight: 1.3kg\n'
                      'Ports: 2x Thunderbolt 4, HDMI, USB-A',
        categories: ['Laptops'],
      ),
      Product(
        imageUrl: 'https://hanoilab.com/wp-content/uploads/2023/06/XPS-15-9530-Core-i7-Ha-noi-Lab.jpg',
        name: 'Dell XPS 15 (16/512GB)',
        price: '45.990.000',
        rating: 4.6,
        reviews: 120,
        description: 'High-performance laptop for professionals and creators.\n'
                      'Display: 15.6" 4K UHD+ OLED, Touch\n'
                      'CPU: Intel Core i9-13900H\n'
                      'RAM: 16GB DDR5\n'
                      'Storage: 512GB SSD\n'
                      'GPU: NVIDIA RTX 4060\n'
                      'Battery: Up to 12 hours\n'
                      'OS: Windows 11 Pro',
        categories: ['Laptops'],
      ),
      Product(
        imageUrl: 'https://sazo.vn/storage/products/yoga-air-15/1-2.png',
        name: 'Lenovo Yoga Slim 7i (16/1TB)',
        price: '27.490.000',
        rating: 4.5,
        reviews: 88,
        description: 'Versatile 2-in-1 laptop with AI-enhanced performance.\n'
                      'Display: 14.5" 3K OLED, Touch\n'
                      'CPU: Intel Core Ultra 5 125H\n'
                      'RAM: 16GB LPDDR5\n'
                      'Storage: 1TB SSD\n'
                      'Battery: Up to 14 hours\n'
                      'OS: Windows 11 Home\n'
                      'Weight: 1.4kg',
        categories: ['Laptops'],
      ),
      Product(
        imageUrl: 'https://lapvip.vn/upload/products/original/hp-spectre-x360-14-2024-nightfall-black-1705650060.jpg',
        name: 'HP Spectre x360 14 (16/512GB)',
        price: '32.990.000',
        rating: 4.7,
        reviews: 105,
        description: 'Premium convertible laptop with vibrant display.\n'
                      'Display: 14" 2.8K OLED, 120Hz\n'
                      'CPU: Intel Core Ultra 7 155H\n'
                      'RAM: 16GB LPDDR5X\n'
                      'Storage: 512GB SSD\n'
                      'Battery: Up to 13 hours\n'
                      'OS: Windows 11 Home\n'
                      'Weight: 1.44kg',
        categories: ['Laptops'],
      ),
      
      // Tablets
      Product(
        imageUrl: 'https://nama.vn/img/upload/images/products/Apple/iPad/Air%20M3/ipad-air-m3-13-inch-blue.png',
        name: 'Apple iPad Air M3 13-inch (8/256GB)',
        price: '19.990.000',
        rating: 4.8,
        reviews: 150,
        description: 'Powerful tablet with M3 chip for work and play.\n'
                      'Display: 13" Liquid Retina, 2732x2048\n'
                      'CPU: Apple M3 8-core\n'
                      'RAM: 8GB\n'
                      'Storage: 256GB\n'
                      'Battery: Up to 10 hours\n'
                      'OS: iPadOS 26\n'
                      'Accessories: Supports Apple Pencil 2, Magic Keyboard',
        categories: ['Tablets'],
      ),
      Product(
        imageUrl: 'https://cdn.tgdd.vn/Products/Images/522/322132/samsung-galaxy-tab-s10-ultra-gray-thumb-600x600.jpg',
        name: 'Samsung Galaxy Tab S10 Ultra (12/256GB)',
        price: '24.990.000',
        rating: 4.6,
        reviews: 110,
        description: 'Premium Android tablet with multitasking prowess.\n'
                      'Display: 14.6" Dynamic AMOLED 2X, 120Hz\n'
                      'CPU: Snapdragon 8 Gen 3\n'
                      'RAM: 12GB\n'
                      'Storage: 256GB\n'
                      'Battery: Up to 18 hours\n'
                      'OS: Android 15, One UI 7\n'
                      'Accessories: S Pen included',
        categories: ['Tablets'],
      ),
      Product(
        imageUrl: 'https://cdn.mobilecity.vn/mobilecity-vn/images/2024/12/w300/oneplus-pad-3-dai-dien.jpg.webp',
        name: 'OnePlus Pad 3 (12/256GB)',
        price: '15.490.000',
        rating: 4.7,
        reviews: 90,
        description: 'High-performance tablet at a midrange price.\n'
                      'Display: 13.2" 3.4K, 144Hz\n'
                      'CPU: Snapdragon 8 Elite\n'
                      'RAM: 12GB\n'
                      'Storage: 256GB\n'
                      'Battery: Up to 12 hours\n'
                      'OS: Android 15\n'
                      'Accessories: Supports stylus, keyboard',
        categories: ['Tablets'],
      ),
      Product(
        imageUrl: 'https://p3-ofp.static.pub//fes/cms/2024/11/26/q5rps6mpnysa0zqwdbd36jneww1xxr703791.png',
        name: 'Lenovo Yoga Tab Plus (8/256GB)',
        price: '12.990.000',
        rating: 4.5,
        reviews: 70,
        description: 'Versatile tablet with AI features and media focus.\n'
                      'Display: 12.7" 3K, 144Hz\n'
                      'CPU: Snapdragon 8 Gen 3\n'
                      'RAM: 8GB\n'
                      'Storage: 256GB\n'
                      'Battery: Up to 12 hours\n'
                      'OS: Android 14\n'
                      'Accessories: Supports 2-in-1 keyboard, Pen Pro',
        categories: ['Tablets'],
      ),
      Product(
        imageUrl: 'https://m.media-amazon.com/images/G/01/kindle/journeys/WTN3CxScwzgi6KWIbtm8Xorm6sx50imat82FEiOH0xK83D/M2JiMjU1ZTYt._CB670552974_.jpg',
        name: 'Amazon Fire HD 10 (4/64GB)',
        price: '3.990.000',
        rating: 4.3,
        reviews: 200,
        description: 'Budget-friendly tablet for media consumption.\n'
                      'Display: 10.1" 1920x1200\n'
                      'CPU: MediaTek Octa-core\n'
                      'RAM: 4GB\n'
                      'Storage: 64GB, microSD up to 1TB\n'
                      'Battery: Up to 10 hours\n'
                      'OS: Fire OS\n'
                      'Accessories: Supports Alexa',
        categories: ['Tablets'],
      ),
      
      // Smart Watches
      Product(
        imageUrl: 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MXM23ref_FV99_VW_34FR+watch-case-46-aluminum-jetblack-nc-s10_VW_34FR+watch-face-46-aluminum-jetblack-s10_VW_34FR?wid=752&hei=720&bgc=fafafa&trim=1&fmt=p-jpg&qlt=80&.v=TnVrdDZWRlZzTURKbHFqOGh0dGpVRW5TeWJ6QW43NUFnQ2V4cmRFc1VnYUdWejZ5THhpKzJwRmRDYlhxN2o5aXB2QjR6TEZ4ZThxM3VqYkZobmlXM3RGNnlaeXQ4NGFKQTAzc0NGeHR2aVk0VEhOZEFKYmY1ZHNpalQ3YVhOWk9WVlBjZVFuazArV21YaFcvTVJ5dzR2eDMxaWg4TFhITTVrUW41Z084dENpYmZuSTdFUnErS0g3SWYxazQrNDdyRzE3K0tORmZaUy9vOVdqTEp2dmJNL3gwYlE3R0w4Z1RCbG9qQTd1MjYyL1owaE5aVCt2Ri82aDRacTg0bXlaZA',
        name: 'Apple Watch Series 10 (46mm)',
        price: '9.990.000',
        rating: 4.8,
        reviews: 250,
        description: 'Advanced smartwatch with comprehensive health tracking.\n'
                      'Display: 46mm OLED Retina, Always-On\n'
                      'Processor: S10 SiP\n'
                      'Features: ECG, Blood Oxygen, Sleep Tracking, Fall Detection\n'
                      'Battery: Up to 18 hours\n'
                      'OS: watchOS 11\n'
                      'Water Resistance: 50m',
        categories: ['Smart Watches'],
      ),
      Product(
        imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/g/r/group_565_1__2.png',
        name: 'Samsung Galaxy Watch 7 (44mm)',
        price: '7.490.000',
        rating: 4.6,
        reviews: 180,
        description: 'Feature-packed smartwatch for Samsung ecosystem users.\n'
                      'Display: 1.5" Super AMOLED, Always-On\n'
                      'Processor: Exynos W1000\n'
                      'Features: Sleep Apnea Detection, Heart Rate, Fitness Tracking\n'
                      'Battery: Up to 40 hours\n'
                      'OS: Wear OS 5\n'
                      'Water Resistance: 5ATM + IP68',
        categories: ['Smart Watches'],
      ),
      Product(
        imageUrl: 'https://cdn.tgdd.vn/Products/Images/7077/329468/garmin-fenix-8-tb-600x600.jpg',
        name: 'Garmin Fenix 8 (47mm)',
        price: '22.990.000',
        rating: 4.7,
        reviews: 95,
        description: 'Rugged smartwatch for fitness and outdoor enthusiasts.\n'
                      'Display: 1.4" MIP, Solar Charging\n'
                      'Processor: Garmin Custom\n'
                      'Features: GPS, Heart Rate, VO2 Max, Sleep Tracking\n'
                      'Battery: Up to 28 days\n'
                      'OS: Garmin OS\n'
                      'Water Resistance: 10ATM',
        categories: ['Smart Watches'],
      ),
      Product(
        imageUrl: 'https://lagihitech.vn/wp-content/uploads/2023/11/dong-ho-thong-minh-Fitbit-Charge-6-hinh-2.jpg',
        name: 'Fitbit Charge 6',
        price: '3.990.000',
        rating: 4.4,
        reviews: 150,
        description: 'Affordable fitness tracker with smartwatch features.\n'
                      'Display: AMOLED, Touch\n'
                      'Features: GPS, Heart Rate, Stress Monitoring, Sleep Tracking\n'
                      'Battery: Up to 7 days\n'
                      'OS: Fitbit OS\n'
                      'Water Resistance: 50m',
        categories: ['Smart Watches'],
      ),
      Product(
        imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/t/e/text_ng_n_19__5_43.png',
        name: 'Amazfit Bip 6',
        price: '2.490.000',
        rating: 4.3,
        reviews: 200,
        description: 'Budget-friendly smartwatch with essential features.\n'
                      'Display: 1.69" TFT, Touch\n'
                      'Features: Heart Rate, SpO2, Sleep Tracking, Stress Monitoring\n'
                      'Battery: Up to 14 days\n'
                      'OS: Zepp OS\n'
                      'Water Resistance: 5ATM',
        categories: ['Smart Watches'],
      ),
    ];
  }

  /// Get categories for home page
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Category(
        icon: 'smartphone',
        label: 'Phones',
      ),
      Category(
        icon: 'tablet_mac',
        label: 'Tablets',
      ),
      Category(
        icon: 'laptop_mac',
        label: 'Laptops',
      ),
      Category(
        icon: 'watch',
        label: 'Smart Watches',
      ),
      Category(
        icon: 'headphones',
        label: 'Accessories',
      ),
    ];
  }

  /// Get home data (products + categories)
  Future<HomeData> getHomeData() async {
    final products = await getProducts();
    final categories = await getCategories();
    
    return HomeData(
      products: products,
      categories: categories,
    );
  }
}

/// Result class for home data
class HomeData {
  final List<Product> products;
  final List<Category> categories;

  HomeData({
    required this.products,
    required this.categories,
  });
}
