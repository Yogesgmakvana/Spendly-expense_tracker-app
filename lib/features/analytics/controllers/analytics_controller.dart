import 'package:get/get.dart';
import '../../../core/database/db_helper.dart';

class AnalyticsController extends GetxController {
  final DBHelper _dbHelper = DBHelper();

  final categorySpending = <String, double>{}.obs;
  final totalExpenseSum = 0.0.obs;
  final totalIncomeSum = 0.0.obs;
  final averageDailySpend = 0.0.obs;
  final highestSpendingCategory = 'Food & Dining'.obs;

  @override
  void onInit() {
    super.onInit();
    calculateAnalytics();
  }

  Future<void> calculateAnalytics() async {
    final txns = await _dbHelper.getTransactions();

    final catMap = <String, double>{};
    double expSum = 0;
    double incSum = 0;

    final now = DateTime.now();

    for (final t in txns) {
      if (t.dateTime.month == now.month && t.dateTime.year == now.year) {
        if (t.isExpense) {
          expSum += t.amount;
          catMap[t.category] = (catMap[t.category] ?? 0) + t.amount;
        } else {
          incSum += t.amount;
        }
      }
    }

    categorySpending.value = catMap;
    totalExpenseSum.value = expSum;
    totalIncomeSum.value = incSum;

    final currentDay = now.day > 0 ? now.day : 1;
    averageDailySpend.value = expSum / currentDay;

    if (catMap.isNotEmpty) {
      String topCat = catMap.keys.first;
      double maxAmt = catMap.values.first;
      catMap.forEach((key, value) {
        if (value > maxAmt) {
          maxAmt = value;
          topCat = key;
        }
      });
      highestSpendingCategory.value = topCat;
    }
  }
}
