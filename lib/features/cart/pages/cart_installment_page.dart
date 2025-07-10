import 'package:flutter/material.dart';

class CartInstallmentPage extends StatefulWidget {
  final double totalAmount;
  const CartInstallmentPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<CartInstallmentPage> createState() => _CartInstallmentPageState();
}

class _CartInstallmentPageState extends State<CartInstallmentPage> {
  int _selectedMonths = 3;
  final List<int> _terms = [3, 6, 12];
  final Map<int, double> _interestRates = {3: 0.0, 6: 0.03, 12: 0.06}; // 0%, 3%, 6%

  @override
  Widget build(BuildContext context) {
    double monthlyPayment = widget.totalAmount / _selectedMonths;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installment Options', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Order Amount', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 4),
            Text('₫${_formatCurrency(widget.totalAmount)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            const SizedBox(height: 24),
            const Text('Choose Installment Term', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: _terms.map((term) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: _buildTermCard(term),
              )).toList(),
            ),
            // const SizedBox(height: 32),
            // Text('Monthly Payment', style: TextStyle(fontSize: 20, color: Colors.grey[700])),
            // const SizedBox(height: 4),
            // Text('₫${monthlyPayment.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF3DDCFF))),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3DDCFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: installment period logic
                },
                child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(num value) {
    return value.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  Widget _buildTermCard(int term) {
    final isSelected = _selectedMonths == term;
    final interest = _interestRates[term] ?? 0.0;
    final totalWithInterest = widget.totalAmount * (1 + interest);
    final monthly = totalWithInterest / term;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMonths = term;
        });
      },
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? const Color(0xFF3DDCFF) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: isSelected ? const Color(0xFF3DDCFF) : Colors.grey.shade300, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$term months', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? Colors.white : Colors.black)),
                const SizedBox(height: 6),
                Text('₫${_formatCurrency(monthly)}/month', style: TextStyle(fontSize: 14, color: isSelected ? Colors.white : Colors.black)),
                const SizedBox(height: 6),
                Text('${(interest * 100).toStringAsFixed(0)}% interest', style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : Colors.grey[700])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
