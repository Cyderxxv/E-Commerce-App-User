import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/loading_circle.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import 'product_detail_page.dart';
import '../../cart/bloc/cart_bloc.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final String? categoryId;
  
  const CategoryProductsPage({
    Key? key,
    required this.categoryName,
    this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF3DDCFC),
          title: Text(
            categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingCircle(),
                    SizedBox(height: 40),
                    Text(
                      'Loading products...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<HomeBloc>().add(LoadHomeData()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is HomeLoaded) {
              print('🏠 HomeLoaded state received with ${state.products.length} products');
              print('📂 Products: ${state.products.map((p) => p.name).toList()}');
              
              // Filter products by category - improved logic with fallback
              List<dynamic> filteredProducts;
              
              if (categoryId != null && categoryId!.isNotEmpty) {
                // Try categoryId filter first
                filteredProducts = state.products
                    .where((product) => product.categoryId.toString() == categoryId)
                    .toList();
                print('🔍 Using categoryId filter: $categoryId, found: ${filteredProducts.length}');
                print('🔍 Products categoryIds: ${state.products.map((p) => '${p.name}: ${p.categoryId}').take(5).toList()}');
                
                // If no products found by categoryId, fallback to keyword filtering
                if (filteredProducts.isEmpty) {
                  filteredProducts = _filterProductsByCategory(state.products, categoryName);
                  print('🔄 Fallback to keyword filter for: $categoryName, found: ${filteredProducts.length}');
                }
              } else {
                // Use keyword-based filtering directly
                filteredProducts = _filterProductsByCategory(state.products, categoryName);
                print('🔍 Using keyword filter for: $categoryName, found: ${filteredProducts.length}');
              }
              
              print('🔍 Filtering for category: $categoryName');
              print('📦 Filtered products: ${filteredProducts.map((p) => p.name).toList()}');

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No products found in $categoryName',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try browsing other categories',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category info header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3DDCFC).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCategoryIcon(categoryName),
                              color: const Color(0xFF3DDCFC),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoryName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${filteredProducts.length} products in $categoryName',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Products grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8, // Tăng một chút để có thêm không gian cho ảnh
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return _buildGridProductCard(
                          product: product,
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  List<dynamic> _filterProductsByCategory(List<dynamic> products, String categoryName) {
    final categoryLower = categoryName.toLowerCase();
    
    return products.where((product) {
      final productName = product.name.toLowerCase();
      final productDesc = product.description.toLowerCase();
      final productBrand = product.brand.toLowerCase();
      
      // Add specific keywords for different categories
      switch (categoryLower) {
        case 'phones':
          return productName.contains('phone') || 
                 productName.contains('iphone') || 
                 productName.contains('samsung galaxy') || 
                 productName.contains('xiaomi') ||
                 productName.contains('oneplus') ||
                 productName.contains('galaxy') ||
                 productName.contains('flip') ||
                 productName.contains('fold') ||
                 productDesc.contains('smartphone') ||
                 productDesc.contains('mobile phone') ||
                 productDesc.contains('flagship') ||
                 productDesc.contains('foldable') ||
                 (productBrand.contains('apple') && (productName.contains('iphone') || productDesc.contains('iphone'))) ||
                 (productBrand.contains('samsung') && (productName.contains('galaxy') || productDesc.contains('phone'))) ||
                 (productBrand.contains('xiaomi') && productDesc.contains('phone'));
                 
        case 'tablets':
          return productName.contains('tablet') || 
                 productName.contains('ipad') ||
                 productName.contains('pad') ||
                 productDesc.contains('tablet') ||
                 (productBrand.contains('apple') && productName.contains('ipad')) ||
                 (productBrand.contains('samsung') && productName.contains('tab')) ||
                 (productBrand.contains('oneplus') && productName.contains('pad'));
                 
        case 'laptops':
          return productName.contains('laptop') || 
                 productName.contains('macbook') ||
                 productName.contains('book') ||
                 productName.contains('thinkpad') ||
                 productName.contains('zenbook') ||
                 productName.contains('xps') ||
                 productName.contains('yoga') ||
                 productName.contains('spectre') ||
                 productDesc.contains('laptop') ||
                 productDesc.contains('ultrabook') ||
                 productDesc.contains('notebook') ||
                 productDesc.contains('convertible') ||
                 (productBrand.contains('apple') && productName.contains('macbook')) ||
                 (productBrand.contains('dell') && productDesc.contains('laptop')) ||
                 (productBrand.contains('hp') && productDesc.contains('laptop')) ||
                 (productBrand.contains('asus') && productDesc.contains('laptop')) ||
                 (productBrand.contains('lenovo') && productDesc.contains('laptop'));
                 
        case 'smart watches':
        case 'watches':
          return productName.contains('watch') || 
                 productName.contains('apple watch') ||
                 productName.contains('galaxy watch') ||
                 productName.contains('fenix') ||
                 productName.contains('fitbit') ||
                 productDesc.contains('smartwatch') ||
                 productDesc.contains('smart watch') ||
                 productDesc.contains('fitness tracker') ||
                 (productBrand.contains('apple') && productName.contains('watch')) ||
                 (productBrand.contains('samsung') && productName.contains('watch')) ||
                 (productBrand.contains('garmin')) ||
                 (productBrand.contains('fitbit'));
                 
        case 'headphones':
        case 'accessories':
          return productName.contains('airpods') ||
                 productName.contains('headphone') ||
                 productName.contains('earphone') ||
                 productName.contains('earbuds') ||
                 productName.contains('case') || 
                 productName.contains('charger') ||
                 productName.contains('cable') ||
                 productName.contains('kindle') ||
                 productDesc.contains('earbuds') ||
                 productDesc.contains('wireless earbuds') ||
                 productDesc.contains('accessory') ||
                 productDesc.contains('accessories') ||
                 productDesc.contains('e-reader') ||
                 (productBrand.contains('apple') && productName.contains('airpods')) ||
                 (productBrand.contains('amazon') && productName.contains('kindle'));
                 
        default:
          // Default filter for other categories
          return productName.contains(categoryLower) ||
                 productDesc.contains(categoryLower) ||
                 productBrand.contains(categoryLower);
      }
    }).toList();
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'phones':
        return Icons.smartphone;
      case 'tablets':
        return Icons.tablet_mac;
      case 'laptops':
        return Icons.laptop_mac;
      case 'smart watches':
        return Icons.watch;
      case 'accessories':
        return Icons.headphones;
      default:
        return Icons.category;
    }
  }

  Widget _buildGridProductCard({
    required dynamic product,
    required BuildContext context,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: BlocProvider.of<CartBloc>(context),
              child: ProductDetailPage(
                imageUrl: product.imageUrl,
                name: product.name,
                price: PriceFormatter.formatPrice(product.price),
                description: product.description,
                rating: product.rating,
                ratingCount: product.reviewCount,
                product: product, // Pass the full product object
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain, // Hiển thị toàn bộ ảnh không bị crop
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Price and Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PriceFormatter.formatPriceWithCurrency(product.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.brown,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '(${product.reviewCount})',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
