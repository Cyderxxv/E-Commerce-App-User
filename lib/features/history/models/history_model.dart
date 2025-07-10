class HistoryModel {
  final String orderId;
  final DateTime date;
  final double totalAmount;

  HistoryModel({
    required this.orderId,
    required this.date,
    required this.totalAmount,
  });

  @override
  String toString() {
    return 'HistoryModel(orderId: $orderId, date: $date, totalAmount: $totalAmount)';
  }
}