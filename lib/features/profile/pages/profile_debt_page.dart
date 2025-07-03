import 'package:cyder_store/features/profile/pages/in_debt_product_page.dart';
import 'package:flutter/material.dart';

class ProfileDebtPage extends StatelessWidget {
  const ProfileDebtPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3DDCFF),
        elevation: 0,
        title: const Text('Debts', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Debt summary card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F6FF),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.emoji_emotions, color: Colors.green, size: 38),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(text: 'You currently have\n'),
                        TextSpan(
                          text: '2.000.000đ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        TextSpan(text: ' in debt'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('Options', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _DebtMenuItem(
            icon: Icons.receipt_long,
            label: 'View in debt products',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InDebtProductPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _DebtMenuItem(
            icon: Icons.favorite_border,
            label: 'Make a payment',
            onTap: () {},
          ),
          const SizedBox(height: 28),
          const Text('Contact', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          _DebtMenuItem(
            icon: Icons.person_outline,
            label: 'Contact us',
            onTap: () {},
          ),
          const SizedBox(height: 32),
          Center(
            child: Text('App version: 0.1', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class _DebtMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _DebtMenuItem({required this.icon, required this.label, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3DDCFF), size: 24),
            const SizedBox(width: 18),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 16)),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
