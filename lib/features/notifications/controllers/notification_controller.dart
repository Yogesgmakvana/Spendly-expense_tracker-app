import 'package:get/get.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/export_helper.dart';
import '../../../models/notification_model.dart';

class NotificationController extends GetxController {
  final notificationService = NotificationService();

  List<NotificationModel> get notifications => notificationService.notificationsList;

  void openFile(String? filePath) {
    if (filePath != null && filePath.isNotEmpty) {
      ExportHelper.openFileLocation(filePath);
    } else {
      Get.toNamed('/export');
    }
  }

  void shareOrDownloadFile(String? filePath) {
    if (filePath != null && filePath.isNotEmpty) {
      ExportHelper.openFileLocation(filePath);
    } else {
      Get.toNamed('/export');
    }
  }

  void clearAllNotifications() {
    notificationService.clearAll();
  }
}
