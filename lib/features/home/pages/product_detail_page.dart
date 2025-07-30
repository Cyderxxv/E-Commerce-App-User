import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/domain/product.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';

class ProductDetailPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String description;
  final double rating;
  final int ratingCount;
  final Product? product; // Add product object for cart operations

  const ProductDetailPage({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
    required this.ratingCount,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          // Product image
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  height: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    height: 240,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          // Product info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  '₫$price',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text('($ratingCount)', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // // Colors
          // Container(
          //   color: Colors.white,
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text('Colors', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          //       const SizedBox(height: 8),
          //       // Row(
          //       //   children: colors.map((color) => _ColorChip(label: color)).toList(),
          //       // ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF3DDCFF)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Color(0xFF3DDCFF)),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DDCFF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Add to cart functionality
                    if (product != null) {
                      context.read<CartBloc>().add(AddToCart(product!));
                      
                      // Show success snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product!.name} added to cart!'),
                          backgroundColor: const Color(0xFF3DDCFF),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      // Fallback: create product from available data
                      final fallbackProduct = Product(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        imageUrl: imageUrl,
                        name: name,
                        description: description,
                        price: double.tryParse(price.replaceAll('₫', '').replaceAll('.', '').replaceAll(',', '')) ?? 0.0,
                        rating: rating,
                        reviewCount: ratingCount,
                        brand: 'Unknown',
                        isFeatured: false,
                        categoryId: '1',
                        stock: 10,
                      );
                      
                      context.read<CartBloc>().add(AddToCart(fallbackProduct));
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name added to cart!'),
                          backgroundColor: const Color(0xFF3DDCFF),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
