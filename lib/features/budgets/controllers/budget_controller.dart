import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/db_helper.dart';
import '../../../models/budget_model.dart';
import '../../../models/recurring_model.dart';

class BudgetController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  final _uuid = const Uuid();

  final budgets = <BudgetModel>[].obs;
  final recurringBills = <RecurringModel>[].obs;

  final totalMonthlyBudget = 1500.0.obs;
  final totalSpentThisMonth = 600.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadBudgetsAndBills();
  }

  Future<void> loadBudgetsAndBills() async {
    final bList = await _dbHelper.getBudgets();
    budgets.value = bList;

    final rList = await _dbHelper.getRecurring();
    recurringBills.value = rList;

    if (bList.isNotEmpty) {
      totalMonthlyBudget.value = bList.first.monthlyLimit;
    }

    final txns = await _dbHelper.getTransactions();
    final now = DateTime.now();
    double spent = 0;
    for (final t in txns) {
      if (t.isExpense && t.dateTime.month == now.month && t.dateTime.year == now.year) {
        spent += t.amount;
      }
    }
    totalSpentThisMonth.value = spent;
  }

  Future<void> setOverallBudget(double limit) async {
    final now = DateTime.now();
    final monthYear = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final budget = BudgetModel(
      id: budgets.isNotEmpty ? budgets.first.id : _uuid.v4(),
      category: 'Overall',
      monthlyLimit: limit,
      warningThreshold: 0.8,
      monthYear: monthYear,
    );

    await _dbHelper.saveBudget(budget);
    await loadBudgetsAndBills();
  }

  Future<void> addRecurringBill({
    required String title,
    required double amount,
    required String category,
    required String frequency,
    required DateTime dueDate,
  }) async {
    final item = RecurringModel(
      id: _uuid.v4(),
      title: title,
      amount: amount,
      category: category,
      frequency: frequency,
      dueDate: dueDate,
    );

    await _dbHelper.saveRecurring(item);
    await loadBudgetsAndBills();
  }

  Future<void> deleteRecurringBill(String id) async {
    await _dbHelper.deleteRecurring(id);
    await loadBudgetsAndBills();
  }
}
