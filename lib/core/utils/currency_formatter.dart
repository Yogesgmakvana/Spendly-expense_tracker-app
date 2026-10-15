import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    double amount, {
    String currencySymbol = '₹',
    bool hideBalance = false,
    bool showSign = false,
  }) {
    if (hideBalance) {
      return '••••••';
    }

    final formatter = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 2,
    );

    final formatted = formatter.format(amount.abs());
    if (showSign) {
      if (amount < 0) return '-$formatted';
      if (amount > 0) return '+$formatted';
    }
    return amount < 0 ? '-$formatted' : formatted;
  }
}
