import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/export_controller.dart';

class ExportView extends GetView<ExportController> {
  const ExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export & Download Data'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Download Financial Data',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'All data is generated locally on your device in standard open formats.',
                style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
              ),
              const SizedBox(height: 20),

              _buildExportCard(
                icon: Icons.table_chart_rounded,
                title: 'Export to CSV',
                subtitle: 'Raw transaction list for Excel / Sheets',
                onTap: () => controller.exportCSV(),
              ),
              const SizedBox(height: 12),

              _buildExportCard(
                icon: Icons.picture_as_pdf_rounded,
                title: 'PDF Financial Summary',
                subtitle: 'Printable financial report',
                onTap: () => controller.exportPDFReport(),
              ),
              const SizedBox(height: 12),

              _buildExportCard(
                icon: Icons.data_object_rounded,
                title: 'Full JSON Backup',
                subtitle: 'Backup database file with schema version',
                onTap: () => controller.exportJSONBackup(),
              ),
              const SizedBox(height: 24),

              Obx(() {
                final msg = controller.exportStatusMessage.value;
                if (msg.isEmpty) return const SizedBox.shrink();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.incomeGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.incomeGreen, width: 1),
                  ),
                  child: SelectableText(
                    msg,
                    style: const TextStyle(color: AppColors.incomeGreen, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Material(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPeach.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryPeach, size: 22),
          ),
          title: Text(title, style: const TextStyle(color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
          trailing: const Icon(Icons.file_download_outlined, color: AppColors.primaryPeach),
        ),
      ),
    );
  }
}
