import 'package:flutter/material.dart';

class ProductCardItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final double rating;
  final int reviews;
  final VoidCallback? onTap;

  const ProductCardItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
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
            // Product Image với AspectRatio cố định
            AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(14),
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
            const SizedBox(height: 8),
            
            // Product Name
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600, 
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Price
            Text(
              '₫$price',
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 15, 
                color: Colors.brown,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Rating Row
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  '$rating',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '($reviews)',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
