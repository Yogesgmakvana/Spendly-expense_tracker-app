import 'package:get/get.dart';
import '../../../core/database/db_helper.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/export_helper.dart';

class ExportController extends GetxController {
  final DBHelper _dbHelper = DBHelper();
  final exportStatusMessage = ''.obs;

  Future<void> exportCSV() async {
    final txns = await _dbHelper.getTransactions();
    final file = await ExportHelper.exportToCSV(txns);
    exportStatusMessage.value = 'Exported CSV: ${file.path}';

    await NotificationService().showExportNotification(
      fileName: 'spendly_transactions.csv',
      filePath: file.path,
    );
  }

  Future<void> exportPDFReport() async {
    final txns = await _dbHelper.getTransactions();
    double inc = 0;
    double exp = 0;
    for (final t in txns) {
      if (t.isIncome) {
        inc += t.amount;
      } else {
        exp += t.amount;
      }
    }

    final file = await ExportHelper.exportFinancialReportPDF(
      txns: txns,
      totalIncome: inc,
      totalExpenses: exp,
      currencySymbol: StorageService.currencySymbol,
    );
    exportStatusMessage.value = 'Exported PDF Report: ${file.path}';

    await NotificationService().showExportNotification(
      fileName: 'spendly_financial_report.pdf',
      filePath: file.path,
    );
  }

  Future<void> exportJSONBackup() async {
    final txns = await _dbHelper.getTransactions();
    final cats = await _dbHelper.getCategories();
    final budgets = await _dbHelper.getBudgets();
    final rec = await _dbHelper.getRecurring();
    final goals = await _dbHelper.getSavingsGoals();

    final file = await ExportHelper.exportFullBackupJSON(
      txns: txns,
      categories: cats,
      budgets: budgets,
      recurring: rec,
      goals: goals,
    );
    exportStatusMessage.value = 'Exported JSON Backup: ${file.path}';

    await NotificationService().showExportNotification(
      fileName: 'spendly_backup.json',
      filePath: file.path,
    );
  }
}
