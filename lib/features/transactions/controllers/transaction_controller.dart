import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/services/storage_service.dart';
import '../../../models/transaction_model.dart';
import '../../../models/category_model.dart';
import '../../home/controllers/home_controller.dart';

class TransactionController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  final _uuid = const Uuid();

  final transactions = <TransactionModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final filteredTransactions = <TransactionModel>[].obs;

  final selectedType = 'expense'.obs; // 'expense' or 'income'
  final searchQuery = ''.obs;
  final selectedCategory = 'All'.obs;

  final todaySpend = 0.0.obs;
  final dailyLimit = 400.0.obs;
  final weeklySpendMap = <int, double>{}.obs; // Day 1-7 (Mon-Sun) -> double amount

  final currencySymbol = '₹'.obs;
  final hideBalance = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    loadData();
  }

  void loadPreferences() {
    currencySymbol.value = StorageService.currencySymbol;
    hideBalance.value = StorageService.hideBalance;
    dailyLimit.value = StorageService.dailyLimit;
  }

  Future<void> loadData() async {
    final list = await _dbHelper.getTransactions();
    transactions.value = list;

    final catList = await _dbHelper.getCategories();
    categories.value = catList;

    calculateTodaySpendAndWeeklyData();
    applyFilter();
  }

  void setTypeFilter(String type) {
    selectedType.value = type;
    applyFilter();
  }

  void applyFilter() {
    var result = transactions.where((t) => t.type.toLowerCase() == selectedType.value.toLowerCase()).toList();

    if (selectedCategory.value != 'All') {
      result = result.where((t) => t.category == selectedCategory.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      result = result.where((t) =>
        t.description.toLowerCase().contains(q) ||
        t.category.toLowerCase().contains(q) ||
        t.notes.toLowerCase().contains(q)
      ).toList();
    }

    filteredTransactions.value = result;
  }

  void calculateTodaySpendAndWeeklyData() {
    final now = DateTime.now();
    double todayTotal = 0;

    final weekMap = <int, double>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    for (final t in transactions) {
      if (t.isExpense) {
        // Check if today
        if (t.dateTime.year == now.year && t.dateTime.month == now.month && t.dateTime.day == now.day) {
          todayTotal += t.amount;
        }

        // Check if in current week
        if (t.dateTime.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            t.dateTime.isBefore(endOfWeek.add(const Duration(days: 1)))) {
          final weekday = t.dateTime.weekday;
          weekMap[weekday] = (weekMap[weekday] ?? 0) + t.amount;
        }
      }
    }

    todaySpend.value = todayTotal;
    weeklySpendMap.value = weekMap;
  }

  Future<void> addTransaction({
    required double amount,
    required String type,
    required String category,
    required DateTime dateTime,
    required String paymentMethod,
    required String description,
    required String notes,
  }) async {
    final newTxn = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      category: category,
      dateTime: dateTime,
      paymentMethod: paymentMethod,
      description: description,
      notes: notes,
    );

    await _dbHelper.insertTransaction(newTxn);
    await loadData();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    await _dbHelper.updateTransaction(txn);
    await loadData();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
  }

  Future<void> deleteTransaction(String id) async {
    await _dbHelper.deleteTransaction(id);
    await loadData();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
  }

  Future<void> duplicateTransaction(TransactionModel txn) async {
    final dup = txn.copyWith(id: _uuid.v4(), dateTime: DateTime.now());
    await _dbHelper.insertTransaction(dup);
    await loadData();

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
  }
}
