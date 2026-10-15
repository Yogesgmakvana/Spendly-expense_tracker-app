import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../app/theme/app_colors.dart';
import '../../models/notification_model.dart';
import '../utils/export_helper.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _uuid = const Uuid();
  final notificationsList = <NotificationModel>[].obs;

  Future<void> init() async {
    final now = DateTime.now();
    notificationsList.value = [
      NotificationModel(
        id: _uuid.v4(),
        title: 'Export Complete',
        body: 'Your Spendly Financial Statement is ready in Downloads.',
        dateTime: now.subtract(const Duration(minutes: 10)),
        type: 'export',
        filePath: '',
      ),
      NotificationModel(
        id: _uuid.v4(),
        title: 'Budget Alert',
        body: 'You have reached 80% of your monthly expense limit.',
        dateTime: now.subtract(const Duration(hours: 2)),
        type: 'budget',
      ),
      NotificationModel(
        id: _uuid.v4(),
        title: 'Bill Due Reminder',
        body: 'Paylater Monthly Bill (₹350.00) is due in 3 days.',
        dateTime: now.subtract(const Duration(hours: 5)),
        type: 'bill',
      ),
    ];
  }

  Future<void> showExportNotification({required String fileName, required String filePath}) async {
    final newNotif = NotificationModel(
      id: _uuid.v4(),
      title: 'Export Complete: $fileName',
      body: 'File saved to Downloads: $filePath',
      dateTime: DateTime.now(),
      filePath: filePath,
      type: 'export',
    );

    notificationsList.insert(0, newNotif);

    Get.snackbar(
      'Export Complete',
      'Saved: $fileName. Tap to open file.',
      backgroundColor: AppColors.incomeGreen,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () {
          ExportHelper.openFileLocation(filePath);
        },
        child: const Text('OPEN FILE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      onTap: (_) {
        ExportHelper.openFileLocation(filePath);
      },
    );
  }

  void clearAll() {
    notificationsList.clear();
  }
}
