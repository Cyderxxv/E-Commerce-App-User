import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../models/cart_item.dart';

class CartConfirmPage extends StatefulWidget {
  const CartConfirmPage({Key? key}) : super(key: key);

  @override
  State<CartConfirmPage> createState() => _CartConfirmPageState();
}

class _CartConfirmPageState extends State<CartConfirmPage> {
  int _shippingOption = 0; // 0: Standard, 1: Express
  int _paymentMethod = 0; // 0: Card, 1: Pay Later

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Order Confirmation', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              final cartItems = state.cartItems;
              final total = cartItems.fold<double>(0, (sum, item) => sum + double.tryParse(item.product.price.replaceAll('.', ''))! * item.quantity);
              final shippingFee = _shippingOption == 0 ? 0 : 30000;
              final totalWithShipping = total + shippingFee;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping Address
                    _sectionCard(
                      title: 'Shipping Address',
                      content: '268 Khu Pho 2, Phuong Bay Hien, Ho Chi Minh City',
                      onEdit: () {},
                    ),
                    const SizedBox(height: 12),
                    // Contact Info
                    _sectionCard(
                      title: 'Contact Information',
                      content: '+84975463190\nphamnguyengiakhiem@gmail.com',
                      onEdit: () {},
                    ),
                    const SizedBox(height: 18),
                    // Items
                    Row(
                      children: [
                        const Text('Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('${cartItems.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...cartItems.map((item) => _cartItemTile(item)).toList(),
                    const SizedBox(height: 18),
                    // Shipping Options
                    const Text('Shipping Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    _shippingOptionTile(0, 'Standard', '5-7 days', 'FREE'),
                    const SizedBox(height: 8),
                    _shippingOptionTile(1, 'Express', '1-2 days', '₫30.000'),
                    const SizedBox(height: 4),
                    Text('Delivered on or before Friday, June 13th 2025', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 18),
                    // Payment Method
                    Row(
                      children: [
                        const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFF3DDCFF)),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _paymentMethodChip(0, 'Card'),
                        const SizedBox(width: 12),
                        _paymentMethodChip(1, 'Pay Later'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Total & Pay Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 16, color: Colors.grey)),
                            Text('₫${_formatPrice(totalWithShipping)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3DDCFF),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: () {},
                          child: const Text('Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required String content, required VoidCallback onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF3DDCFF)),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _cartItemTile(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.product.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(width: 48, height: 48, color: Colors.grey[200]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Text(item.product.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('₫${item.product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _shippingOptionTile(int value, String label, String time, String price) {
    return GestureDetector(
      onTap: () => setState(() => _shippingOption = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _shippingOption == value ? const Color(0xFFE8F6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _shippingOption == value ? const Color(0xFF3DDCFF) : Colors.grey.shade300, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(_shippingOption == value ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xFF3DDCFF)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(time, style: const TextStyle(color: Color(0xFF3DDCFF), fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            Text(price, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: price == 'FREE' ? Colors.green : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodChip(int value, String label) {
    final isSelected = _paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (value == 0 ? const Color(0xFF3DDCFF) : const Color(0xFFB2F2D7)) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? (value == 0 ? const Color(0xFF3DDCFF) : const Color(0xFFB2F2D7)) : Colors.grey.shade300, width: 1.5),
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
      ),
    );
  }

  String _formatPrice(double price) {
    final s = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
