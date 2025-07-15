import '../models/history_model.dart';

class HistoryRepository {
  // Mock history data
  static final List<HistoryModel> _mockHistoryData = [
    HistoryModel(
      orderId: 'ORD-2025-001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      totalAmount: 25650600,
    ),
    HistoryModel(
      orderId: 'ORD-2025-002',
      date: DateTime.now().subtract(const Duration(days: 3)),
      totalAmount: 14550200,
    ),
    HistoryModel(
      orderId: 'ORD-2025-003',
      date: DateTime.now().subtract(const Duration(days: 7)),
      totalAmount: 32990000,
    ),
    HistoryModel(
      orderId: 'ORD-2025-004',
      date: DateTime.now().subtract(const Duration(days: 14)),
      totalAmount: 20550200,
    ),
    HistoryModel(
      orderId: 'ORD-2025-005',
      date: DateTime.now().subtract(const Duration(days: 21)),
      totalAmount: 30550200,
    ),
  ];

  /// Get user's order history
  Future<List<HistoryModel>> getOrderHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Return copy of mock data
    return List.from(_mockHistoryData);
  }

  /// Get specific order details
  Future<HistoryModel?> getOrderDetails(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      return _mockHistoryData.firstWhere(
        (order) => order.orderId == orderId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get order history within date range
  Future<List<HistoryModel>> getOrderHistoryByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return _mockHistoryData.where((order) {
      return order.date.isAfter(startDate) && order.date.isBefore(endDate);
    }).toList();
  }

  /// Get recent orders (last 30 days)
  Future<List<HistoryModel>> getRecentOrders() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    
    return _mockHistoryData.where((order) {
      return order.date.isAfter(thirtyDaysAgo);
    }).toList();
  }

  /// Get total spent amount
  Future<double> getTotalSpent() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockHistoryData.fold<double>(
      0,
      (sum, order) => sum + order.totalAmount,
    );
  }

  /// Get order count
  Future<int> getOrderCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockHistoryData.length;
  }

  /// Search orders by order ID or amount
  Future<List<HistoryModel>> searchOrders(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final lowercaseQuery = query.toLowerCase();
    
    return _mockHistoryData.where((order) {
      return order.orderId.toLowerCase().contains(lowercaseQuery) ||
             order.totalAmount.toString().contains(query);
    }).toList();
  }
}
