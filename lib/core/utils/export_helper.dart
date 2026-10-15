import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/budget_model.dart';
import '../../models/recurring_model.dart';
import '../../models/savings_goal_model.dart';

class ExportHelper {
  static const _platform = MethodChannel('com.spendly.app/biometrics');

  /// Get target device Downloads directory path
  static Future<Directory> getTargetExportDirectory() async {
    if (Platform.isAndroid) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return downloadDir;
      }
    }
    final systemDownloadsDir = await getDownloadsDirectory();
    if (systemDownloadsDir != null && await systemDownloadsDir.exists()) {
      return systemDownloadsDir;
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Open downloaded file location / launch file via Native MethodChannel or url_launcher
  static Future<void> openFileLocation(String filePath) async {
    try {
      final bool? success = await _platform.invokeMethod<bool>('openFile', {'filePath': filePath});
      if (success == true) return;
    } catch (_) {}

    try {
      final fileUri = Uri.file(filePath);
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
      } else {
        final parentDir = File(filePath).parent;
        final dirUri = Uri.file(parentDir.path);
        if (await canLaunchUrl(dirUri)) {
          await launchUrl(dirUri);
        }
      }
    } catch (_) {}
  }

  // --- CSV Export ---
  static Future<File> exportToCSV(List<TransactionModel> txns) async {
    final buffer = StringBuffer();
    buffer.writeln('ID,Date,Type,Category,Amount,PaymentMethod,Description,Notes');

    for (final t in txns) {
      final line = [
        t.id,
        t.dateTime.toIso8601String(),
        t.type,
        '"${t.category.replaceAll('"', '""')}"',
        t.amount.toStringAsFixed(2),
        t.paymentMethod,
        '"${t.description.replaceAll('"', '""')}"',
        '"${t.notes.replaceAll('"', '""')}"',
      ].join(',');
      buffer.writeln(line);
    }

    final dir = await getTargetExportDirectory();
    final file = File('${dir.path}/Spendly_Transactions_${DateTime.now().millisecondsSinceEpoch}.csv');
    return await file.writeAsString(buffer.toString());
  }

  // --- JSON Full Backup Export ---
  static Future<File> exportFullBackupJSON({
    required List<TransactionModel> txns,
    required List<CategoryModel> categories,
    required List<BudgetModel> budgets,
    required List<RecurringModel> recurring,
    required List<SavingsGoalModel> goals,
  }) async {
    final backupMap = {
      'app': 'Spendly',
      'version': '1.0.0',
      'exportTimestamp': DateTime.now().toIso8601String(),
      'transactions': txns.map((t) => t.toMap()).toList(),
      'categories': categories.map((c) => c.toMap()).toList(),
      'budgets': budgets.map((b) => b.toMap()).toList(),
      'recurring': recurring.map((r) => r.toMap()).toList(),
      'savingsGoals': goals.map((g) => g.toMap()).toList(),
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(backupMap);
    final dir = await getTargetExportDirectory();
    final file = File('${dir.path}/Spendly_Backup_${DateTime.now().millisecondsSinceEpoch}.json');
    return await file.writeAsString(jsonStr);
  }

  // --- Professional Clean PDF Financial Summary Statement ---
  static Future<File> exportFinancialReportPDF({
    required List<TransactionModel> txns,
    required double totalIncome,
    required double totalExpenses,
    required String currencySymbol,
  }) async {
    final netSavings = totalIncome - totalExpenses;
    final nowStr = DateTime.now().toString().split('.')[0];
    final symbol = (currencySymbol == '₹' || currencySymbol.contains('₹')) ? 'Rs. ' : '$currencySymbol ';

    final lines = <String>[
      '==========================================================',
      '                SPENDLY FINANCIAL STATEMENT             ',
      '==========================================================',
      'Generated Date : $nowStr',
      'Account Status : Active / Verified',
      '----------------------------------------------------------',
      'EXECUTIVE SUMMARY:',
      '  Total Monthly Income   : $symbol${totalIncome.toStringAsFixed(2)}',
      '  Total Monthly Expenses : $symbol${totalExpenses.toStringAsFixed(2)}',
      '  Net Monthly Savings    : $symbol${netSavings.toStringAsFixed(2)}',
      '----------------------------------------------------------',
      'TRANSACTION DETAILS LOG:',
      '',
      'DATE       | CATEGORY            | TYPE    | AMOUNT       ',
      '----------------------------------------------------------',
    ];

    for (final t in txns) {
      final dateStr = t.dateTime.toString().split(' ')[0];
      final catStr = t.category.padRight(19).length > 19
          ? t.category.substring(0, 19)
          : t.category.padRight(19);
      final typeStr = (t.isExpense ? 'EXPENSE' : 'INCOME').padRight(7);
      final sign = t.isExpense ? '-' : '+';
      final amtStr = '$sign$symbol${t.amount.toStringAsFixed(2)}';

      lines.add('$dateStr | $catStr | $typeStr | $amtStr');
      if (t.description.isNotEmpty && t.description != t.category) {
        lines.add('  Note: ${t.description}');
      }
    }

    lines.add('==========================================================');
    lines.add('End of Report - Spendly Personal Finance Manager');

    final pdfBytes = _generatePdfBytes(lines);
    final dir = await getTargetExportDirectory();
    final file = File('${dir.path}/Spendly_Financial_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    return await file.writeAsBytes(pdfBytes);
  }

  static List<int> _generatePdfBytes(List<String> textLines) {
    final streamContent = StringBuffer();
    streamContent.writeln('BT');
    streamContent.writeln('/F1 10 Tf');
    streamContent.writeln('13 TL');
    streamContent.writeln('40 760 Td');

    for (int i = 0; i < textLines.length && i < 52; i++) {
      final sanitized = textLines[i]
          .replaceAll('\\', '\\\\')
          .replaceAll('(', '\\(')
          .replaceAll(')', '\\)');
      streamContent.writeln('($sanitized) Tj');
      streamContent.writeln('T*');
    }
    streamContent.writeln('ET');

    final streamBytes = utf8.encode(streamContent.toString());

    final objects = <String>[];
    objects.add('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj');
    objects.add('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj');
    objects.add('3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R /Resources << /Font << /F1 5 0 R >> >> >>\nendobj');
    objects.add('4 0 obj\n<< /Length ${streamBytes.length} >>\nstream\n${streamContent.toString()}endstream\nendobj');
    objects.add('5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>\nendobj');

    final pdfHeader = '%PDF-1.4\n';
    int currentOffset = pdfHeader.length;
    final offsets = <int>[];

    final bodyBuffer = StringBuffer();
    for (final obj in objects) {
      offsets.add(currentOffset);
      bodyBuffer.writeln(obj);
      currentOffset += utf8.encode('$obj\n').length;
    }

    final startXref = currentOffset;
    final xrefBuffer = StringBuffer();
    xrefBuffer.writeln('xref');
    xrefBuffer.writeln('0 ${objects.length + 1}');
    xrefBuffer.writeln('0000000000 65535 f ');

    for (final offset in offsets) {
      xrefBuffer.writeln('${offset.toString().padLeft(10, '0')} 00000 n ');
    }

    xrefBuffer.writeln('trailer');
    xrefBuffer.writeln('<< /Size ${objects.length + 1} /Root 1 0 R >>');
    xrefBuffer.writeln('startxref');
    xrefBuffer.writeln('$startXref');
    xrefBuffer.writeln('%%EOF');

    final fullPdfString = '$pdfHeader${bodyBuffer.toString()}${xrefBuffer.toString()}';
    return utf8.encode(fullPdfString);
  }
}
