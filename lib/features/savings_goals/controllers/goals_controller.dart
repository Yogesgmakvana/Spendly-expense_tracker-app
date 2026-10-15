import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/db_helper.dart';
import '../../../models/savings_goal_model.dart';

class GoalsController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  final _uuid = const Uuid();

  final goals = <SavingsGoalModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<void> loadGoals() async {
    final list = await _dbHelper.getSavingsGoals();
    goals.value = list;
  }

  Future<void> addGoal({
    required String title,
    required double targetAmount,
    required double initialSaved,
    required DateTime targetDate,
    required String notes,
  }) async {
    final newGoal = SavingsGoalModel(
      id: _uuid.v4(),
      title: title,
      targetAmount: targetAmount,
      currentSaved: initialSaved,
      targetDate: targetDate,
      notes: notes,
    );

    await _dbHelper.saveSavingsGoal(newGoal);
    await loadGoals();
  }

  Future<void> contributeToGoal(String id, double amount) async {
    final index = goals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final goal = goals[index];
      final updated = goal.copyWith(currentSaved: goal.currentSaved + amount);
      await _dbHelper.saveSavingsGoal(updated);
      await loadGoals();
    }
  }

  Future<void> deleteGoal(String id) async {
    await _dbHelper.deleteSavingsGoal(id);
    await loadGoals();
  }
}
