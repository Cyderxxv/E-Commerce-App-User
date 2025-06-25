import 'package:flutter/material.dart';

class ProductCardItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final double rating;
  final int reviews;

  const ProductCardItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 6),
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
              height: 110,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '₫$price',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 5),
              Text('$rating', style: TextStyle(fontSize: 15)),
              const SizedBox(width: 5),
              Text('($reviews)', style: TextStyle(fontSize: 15, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
