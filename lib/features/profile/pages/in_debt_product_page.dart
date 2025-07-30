import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/domain/product.dart';

class InDebtProductPage extends StatelessWidget {
  final List<InDebtProduct> inDebtProducts;

  InDebtProductPage({
    Key? key,
    List<InDebtProduct>? inDebtProducts,
  })  : inDebtProducts = inDebtProducts ?? _defaultInDebtProducts,
        super(key: key);

  static final List<InDebtProduct> _defaultInDebtProducts = [
    InDebtProduct(
      product: Product(
        id: '1',
        imageUrl: 'https://cdn.viettablet.com/images/detailed/66/samsung-galaxy-s25-edge-111.jpg',
        name: 'Samsung Galaxy S25 Edge (12/256GB)',
        price: 25650600.0,
        rating: 4.9,
        reviewCount: 256,
        description: 'Flagship Samsung with stunning display and performance.',
        brand: 'Samsung',
        isFeatured: true,
        categoryId: '1',
        stock: 10,
      ),
      paidMonths: 4,
      totalMonths: 12,
      totalDebt: 25650600,
      paidAmount: 8550200,
    ),
    InDebtProduct(
      product: Product(
        id: '2',
        imageUrl: 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/i/p/iphone-16-pro-2.png',
        name: 'Apple iPhone 16 Pro Max (12/256GB)',
        price: 32990000.0,
        rating: 4.7,
        reviewCount: 300,
        description: 'Apple latest  with advanced camera.',
        brand: 'Apple',
        isFeatured: true,
        categoryId: '1',
        stock: 5,
      ),
      paidMonths: 2,
      totalMonths: 10,
      totalDebt: 32990000,
      paidAmount: 6598000,
    ),
  ];

  int get totalDebt => inDebtProducts.fold(0, (sum, e) => sum + e.totalDebt);
  int get totalPaid => inDebtProducts.fold(0, (sum, e) => sum + e.paidAmount);

  @override
  Widget build(BuildContext context) {
    final percent = totalDebt == 0 ? 0.0 : totalPaid / totalDebt;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3DDCFF),
        elevation: 0,
        title: const Text('In-debt Products', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Chart showing debt payment progress
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your debt payment progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Center(
                              child: Text(
                                '${(percent * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                          ),
                        ],
                        series: <DoughnutSeries<_DebtChartData, String>>[
                          DoughnutSeries<_DebtChartData, String>(
                            dataSource: [
                              _DebtChartData('Paid', totalPaid, const Color(0xFF3DDCFF)),
                              _DebtChartData('Unpaid', totalDebt - totalPaid, Colors.grey[300]!),
                            ],
                            xValueMapper: (_DebtChartData data, _) => data.label,
                            yValueMapper: (_DebtChartData data, _) => data.value,
                            pointColorMapper: (_DebtChartData data, _) => data.color,
                            radius: '90%',
                            innerRadius: '70%',
                            dataLabelSettings: const DataLabelSettings(isVisible: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paid: ₫${_formatPrice(totalPaid)}', style: const TextStyle(fontSize: 15, color: Colors.green)),
                        Text('Total: ₫${_formatPrice(totalDebt)}', style: const TextStyle(fontSize: 15, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text('Products in debt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ...inDebtProducts.map((e) => _InDebtProductItem(item: e)).toList(),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class InDebtProduct {
  final Product product;
  final int paidMonths;
  final int totalMonths;
  final int totalDebt;
  final int paidAmount;
  const InDebtProduct({
    required this.product,
    required this.paidMonths,
    required this.totalMonths,
    required this.totalDebt,
    required this.paidAmount,
  });
}

class _InDebtProductItem extends StatelessWidget {
  final InDebtProduct item;
  const _InDebtProductItem({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = item.totalMonths == 0 ? 0.0 : item.paidMonths / item.totalMonths;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('Paid: ${item.paidMonths}/${item.totalMonths} months', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: percent,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3DDCFF)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₫${_formatPrice(item.totalDebt)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text('${(percent * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 13, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _DebtChartData {
  final String label;
  final int value;
  final Color color;
  _DebtChartData(this.label, this.value, this.color);
}