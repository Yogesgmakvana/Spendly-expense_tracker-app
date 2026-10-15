import 'package:get/get.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/services/storage_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../transactions/controllers/transaction_controller.dart';

class SettingsController extends GetxController {
  final DBHelper _dbHelper = DBHelper();

  final currencySymbol = '\$'.obs;
  final hideBalance = false.obs;
  final biometricsEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    currencySymbol.value = StorageService.currencySymbol;
    hideBalance.value = StorageService.hideBalance;
    biometricsEnabled.value = StorageService.isBiometricsEnabled;
  }

  Future<void> changeCurrency(String symbol) async {
    currencySymbol.value = symbol;
    await StorageService.setCurrencySymbol(symbol);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadPreferences();
    }
    if (Get.isRegistered<TransactionController>()) {
      Get.find<TransactionController>().loadPreferences();
    }
  }

  Future<void> toggleHideBalance(bool val) async {
    hideBalance.value = val;
    await StorageService.setHideBalance(val);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().toggleHideBalance();
    }
  }

  Future<void> resetAllData() async {
    await _dbHelper.clearAllData();
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshDashboard();
    }
    if (Get.isRegistered<TransactionController>()) {
      Get.find<TransactionController>().loadData();
    }
  }
}
