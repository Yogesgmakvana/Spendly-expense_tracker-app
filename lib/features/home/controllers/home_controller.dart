import 'package:get/get.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/transaction_model.dart';
import '../../../models/recurring_model.dart';

class HomeController extends GetxController {
  final DBHelper _dbHelper = DBHelper();

  final isLoading = true.obs;
  final totalBalance = 0.0.obs;
  final totalIncome = 0.0.obs;
  final totalExpenses = 0.0.obs;
  final billsDueTotal = 0.0.obs;
  final netChange = 0.0.obs;

  final hideBalance = false.obs;
  final currencySymbol = '₹'.obs;

  final recentTransactions = <TransactionModel>[].obs;
  final activeBills = <RecurringModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    refreshDashboard();
  }

  void loadPreferences() {
    hideBalance.value = StorageService.hideBalance;
    currencySymbol.value = StorageService.currencySymbol;
  }

  void toggleHideBalance() {
    hideBalance.value = !hideBalance.value;
    StorageService.setHideBalance(hideBalance.value);
  }

  Future<void> refreshDashboard() async {
    isLoading.value = true;
    final txns = await _dbHelper.getTransactions();
    recentTransactions.value = txns;

    double allInc = 0;
    double allExp = 0;

    double monthInc = 0;
    double monthExp = 0;

    final now = DateTime.now();

    for (final t in txns) {
      if (t.isIncome) {
        allInc += t.amount;
        if (t.dateTime.month == now.month && t.dateTime.year == now.year) {
          monthInc += t.amount;
        }
      } else {
        allExp += t.amount;
        if (t.dateTime.month == now.month && t.dateTime.year == now.year) {
          monthExp += t.amount;
        }
      }
    }

    totalIncome.value = monthInc;
    totalExpenses.value = monthExp;
    netChange.value = monthInc - monthExp;
    totalBalance.value = allInc - allExp;

    // Load active bills
    final bills = await _dbHelper.getRecurring();
    activeBills.value = bills;

    double billsSum = 0;
    for (final b in bills) {
      if (!b.isPaid) {
        billsSum += b.amount;
      }
    }
    billsDueTotal.value = billsSum;

    Future.delayed(const Duration(milliseconds: 300), () {
      isLoading.value = false;
    });
  }
}
