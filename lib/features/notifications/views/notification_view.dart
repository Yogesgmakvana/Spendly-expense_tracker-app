import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.primaryPeach),
            onPressed: () => controller.clearAllNotifications(),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final list = controller.notifications;
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.darkCardSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_off_outlined,
                      size: 48,
                      color: AppColors.primaryPeach,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are all caught up! No recent alerts or export notifications.',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final notif = list[index];

              IconData icon = Icons.notifications_active_rounded;
              Color iconColor = AppColors.primaryPeach;

              if (notif.type == 'export') {
                icon = Icons.file_download_done_rounded;
                iconColor = AppColors.incomeGreen;
              } else if (notif.type == 'budget') {
                icon = Icons.warning_amber_rounded;
                iconColor = AppColors.warningOrange;
              } else if (notif.type == 'bill') {
                icon = Icons.receipt_long_rounded;
                iconColor = AppColors.infoBlue;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.body,
                                style: const TextStyle(
                                  color: AppColors.textSecondaryDark,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('MMM dd, hh:mm a').format(notif.dateTime),
                                style: const TextStyle(
                                  color: AppColors.textMutedDark,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Action Buttons Row (Expanded on both sides to prevent any horizontal overflow)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => controller.shareOrDownloadFile(notif.filePath),
                            icon: const Icon(Icons.share_outlined, size: 15, color: AppColors.primaryPeach),
                            label: const Text(
                              'Share / Save',
                              style: TextStyle(color: AppColors.primaryPeach, fontSize: 11, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              side: const BorderSide(color: AppColors.darkCardBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => controller.openFile(notif.filePath),
                            icon: const Icon(Icons.folder_open_rounded, size: 15, color: AppColors.darkBackground),
                            label: const Text(
                              'Open File',
                              style: TextStyle(color: AppColors.darkBackground, fontSize: 11, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              backgroundColor: AppColors.primaryPeach,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
