import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widget/product_card_item.dart';
import '../../cores/widgets/loading_circle.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          // Background color
          backgroundColor: Color(0xFFF8F8F8),
          body: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadingCircle(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('App is still running')),
                          );
                        },
                        child: const Text('App status check'),
                      ),
                    ],
                  );
                } else if (state is HomeError) {
                  return Center(child: Text(state.message));
                } else if (state is HomeLoaded) {
                  final products = state.products;
                  final categories = state.categories;
                  return SingleChildScrollView(
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
                                    fillColor: Colors.white,
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
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final p = products[index];
                                return ProductCardItem(
                                  imageUrl: p.imageUrl,
                                  name: p.name,
                                  price: p.price,
                                  rating: p.rating,
                                  reviews: p.reviews,
                                );
                              },
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
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 1.7,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final c = categories[index];
                              // Assign colors based on index or label
                              Color bgColor;
                              Color iconColor;
                              switch (c.label) {
                                case 'Phones':
                                  bgColor = const Color.fromARGB(102, 199, 196, 196);
                                  iconColor = Colors.teal;
                                  break;
                                case 'Tablets':
                                  bgColor = Colors.blue[50]!;
                                  iconColor = Colors.blueAccent;
                                  break;
                                case 'Accessories':
                                  bgColor = Colors.purple[50]!;
                                  iconColor = Colors.purple;
                                  break;
                                case 'Laptops':
                                  bgColor = Colors.amber[50]!;
                                  iconColor = Colors.amber[800]!;
                                  break;
                                default:
                                  bgColor = Colors.grey[200]!;
                                  iconColor = Colors.grey;
                              }
                              return _CategoryCard(
                                icon: _iconFromString(c.icon),
                                label: c.label,
                                color: bgColor,
                                iconColor: iconColor,
                                height: 90,
                                onTap: () {
                                  // TODO: Implement navigation or action for category
                                  print('${c.label} tapped');
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          bottomNavigationBar: null,
        ),
      ),
    );
  }
}

IconData _iconFromString(String iconName) {
  switch (iconName) {
    case 'smartphone':
      return Icons.smartphone;
    case 'tablet_mac':
      return Icons.tablet_mac;
    case 'headphones':
      return Icons.headphones;
    case 'laptop_mac':
      return Icons.laptop_mac;
    // ...other cases...
    default:
      return Icons.category;
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
