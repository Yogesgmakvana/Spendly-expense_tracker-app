import 'package:get/get.dart';
import '../../features/navigation/controllers/navigation_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/transactions/controllers/transaction_controller.dart';
import '../../features/budgets/controllers/budget_controller.dart';
import '../../features/analytics/controllers/analytics_controller.dart';
import '../../features/savings_goals/controllers/goals_controller.dart';
import '../../features/export/controllers/export_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../features/security/controllers/security_controller.dart';
import '../../features/notifications/controllers/notification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(TransactionController(), permanent: true);
    Get.put(BudgetController(), permanent: true);
    Get.put(AnalyticsController(), permanent: true);
    Get.put(GoalsController(), permanent: true);
    Get.put(ExportController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(SecurityController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}
