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
        // Background color
        backgroundColor: Color(0xFFF8F8F8),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
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
                          name: 'Samsung Galaxy S25 Edge (12/256GB)',
                          price: '25.650.600',
                          rating: 4.9,
                          reviews: 256,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn.mobilecity.vn/mobilecity-vn/images/2025/05/w300/xiaomi-15s-pro-den-cac-bon.jpg.webp',
                          name: 'Xiaomi 15S PRO (12/256GB)',
                          price: '14.550.200',
                          rating: 4.8,
                          reviews: 128,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-16-pro-2.png',
                          name: 'Apple iPhone 16 Pro Max (12/256GB)',
                          price: '32.990.000',
                          rating: 4.7,
                          reviews: 300,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung-galaxy-z-flip-6-xanh-duong-4_2.png',
                          name: 'Samsung Galaxy Z Flip6 (12/256GB)',
                          price: '20.550.200',
                          rating: 4.0,
                          reviews: 52,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://thetekcoffee.com/wp-content/uploads/2024/07/galaxy-z-fold6-han-quoc.png',
                          name: 'Samsung Galaxy Z Fold6 (12/256GB)',
                          price: '30.550.200',
                          rating: 4.5,
                          reviews: 72,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://vcdn1-sohoa.vnecdn.net/2024/09/10/HUAWEI-Mate-XT-rear-finish-102-3717-1695-1725962087.jpg?w=460&h=0&q=100&dpr=2&fit=crop&s=9J9OaUNggWV_7bn6ZEn6Ew',
                          name: 'HUAWEI Mate XT (16/512GB)',
                          price: '69.990.000',
                          rating: 4.5,
                          reviews: 72,
                        ),
                        const SizedBox(width: 12),
                        _ProductCard(
                          imageUrl: 'https://cdn-v2.didongviet.vn/files/products/2024/8/27/1/1727428395607_cusac57.png',
                          name: 'U-Green Charger 65W GaN',
                          price: '650.000',
                          rating: 4.8,
                          reviews: 222,
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
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.7,
                    children: [
                      _CategoryCard(
                        icon: Icons.outdoor_grill,
                        label: 'Outdoor',
                        color: Colors.green[50]!,
                        iconColor: Colors.green,
                        height: 90,
                        onTap: () {
                          // TODO: Implement navigation or action for Outdoor
                          print('Outdoor tapped');
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.kitchen,
                        label: 'Appliances',
                        color: Colors.blue[50]!,
                        iconColor: Colors.blue,
                        height: 90,
                        onTap: () {
                          // TODO: Implement navigation or action for Appliances
                          print('Appliances tapped');
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.chair,
                        label: 'Furniture',
                        color: Colors.orange[50]!,
                        iconColor: Colors.orange,
                        height: 90,
                        onTap: () {
                          // TODO: Implement navigation or action for Furniture
                          print('Furniture tapped');
                        },
                      ),
                      _CategoryCard(
                        icon: Icons.more_horiz,
                        label: 'See More',
                        color: Colors.grey[200]!,
                        iconColor: Colors.grey,
                        height: 90,
                        onTap: () {
                          // TODO: Implement navigation or action for See More
                          print('See More tapped');
                        },
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

class _CategoryCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final double height;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.height = 80,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
    _controller.addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: (details) {
          _onTapUp(details);
          if (widget.onTap != null) widget.onTap!();
        },
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.iconColor, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
