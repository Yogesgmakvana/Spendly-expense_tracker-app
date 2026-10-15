import 'package:intl/intl.dart';

class DateFormatter {
  static String formatShort(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatWithDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today, ${DateFormat('MMM dd').format(date)}';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat('MMM dd').format(date)}';
    }
    return DateFormat('E, MMM dd, yyyy').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
