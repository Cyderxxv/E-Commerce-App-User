import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cyder_store/cores/widgets/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8F8), // Set a light background color
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search products',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.notifications_none, size: 28, color: Colors.grey[700]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Delivery address
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.black),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Deliver to  CC Bau Cat 2, phuong 10, quan ...',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // New Products title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'New Products',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text('See More', style: TextStyle(color: Colors.blue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Products List
                  SizedBox(
                    height: 300,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _ProductCard(
                          imageUrl: 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg',
                          name: 'Samsung Galaxy S25 (12GB/256GB)',
                          price: '25.650.600',
                          rating: 4.9,
                          reviews: 256,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp',
                          name: 'Xiaomi 15S PRO (12GB/256GB)',
                          price: '14.550.200',
                          rating: 4.8,
                          reviews: 128,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-16-pro-2.png',
                          name: 'iPhone 16 Pro Max (12GB/256GB)',
                          price: '32.990.000',
                          rating: 4.7,
                          reviews: 300,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Shop by Categories title
                  Text(
                    'Shop by Categories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  // Categories grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.2,
                    children: [
                      _CategoryCard(
                        icon: Icons.outdoor_grill,
                        label: 'Outdoor',
                        color: Colors.green[50]!,
                        iconColor: Colors.green,
                      ),
                      _CategoryCard(
                        icon: Icons.kitchen,
                        label: 'Appliances',
                        color: Colors.blue[50]!,
                        iconColor: Colors.blue,
                      ),
                      _CategoryCard(
                        icon: Icons.chair,
                        label: 'Furniture',
                        color: Colors.orange[50]!,
                        iconColor: Colors.orange,
                      ),
                      _CategoryCard(
                        icon: Icons.more_horiz,
                        label: 'See More',
                        color: Colors.grey[200]!,
                        iconColor: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            // TODO: Implement navigation logic for other tabs if needed
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final double rating;
  final int reviews;

  const _ProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Slightly larger radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 6), // Slightly larger offset
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              height: 110, // Increased height
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12), // Increased spacing
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17), // Larger font
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '₫$price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown), // Larger font
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18), // Larger icon
              const SizedBox(width: 5),
              Text('$rating', style: TextStyle(fontSize: 15)), // Larger font
              const SizedBox(width: 5),
              Text('($reviews)', style: TextStyle(fontSize: 15, color: Colors.grey)), // Larger font
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
