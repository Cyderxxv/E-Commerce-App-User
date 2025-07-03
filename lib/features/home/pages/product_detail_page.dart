import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String description;
  final double rating;
  final int ratingCount;
  // final List<String> colors;

  const ProductDetailPage({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
    required this.ratingCount,
    // required this.colors,
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
                  onPressed: () {},
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

class _ColorChip extends StatelessWidget {
  final String label;
  const _ColorChip({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3DDCFF)),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF3DDCFF), fontWeight: FontWeight.bold)),
    );
  }
}
