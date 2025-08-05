import 'package:intl/intl.dart';

class PriceFormatter {
  static final NumberFormat _currencyFormatter = NumberFormat('#,###', 'vi_VN');
  
  /// Format giá tiền với dấu phẩy ngăn cách (ví dụ: 25,650,600)
  static String formatPrice(num price) {
    return _currencyFormatter.format(price);
  }
  
  /// Format giá tiền với đơn vị VND (ví dụ: 25,650,600₫)
  static String formatPriceWithCurrency(num price) {
    return '${formatPrice(price)}₫';
  }
  
  /// Format giá tiền compact (ví dụ: 25.6M₫)
  static String formatPriceCompact(num price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M₫';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K₫';
    } else {
      return '${price.toInt()}₫';
    }
  }
  
  /// Format giá tiền với màu sắc (cho rich text)
  static String formatPriceWithStyle(num price, {bool showCurrency = true}) {
    String formattedPrice = formatPrice(price);
    return showCurrency ? '$formattedPrice₫' : formattedPrice;
  }
  
  /// Tách phần số và đơn vị để styling riêng biệt
  static Map<String, String> getPriceParts(num price) {
    return {
      'number': formatPrice(price),
      'currency': '₫'
    };
  }
  
  /// Format cho installment payment
  static String formatInstallmentPrice(num monthlyPayment, int months) {
    return '${formatPriceWithCurrency(monthlyPayment)}/month x $months months';
  }
  
  /// Format discount percentage
  static String formatDiscountPercentage(num originalPrice, num discountPrice) {
    if (originalPrice <= discountPrice) return '';
    
    double percentage = ((originalPrice - discountPrice) / originalPrice) * 100;
    return '-${percentage.toStringAsFixed(0)}%';
  }
  
  /// Format savings amount
  static String formatSavings(num originalPrice, num discountPrice) {
    if (originalPrice <= discountPrice) return '';
    
    num savings = originalPrice - discountPrice;
    return 'Tiết kiệm ${formatPriceWithCurrency(savings)}';
  }
}
