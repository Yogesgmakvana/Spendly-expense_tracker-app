import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';

class ProcessingOverlay {
  static void show({String message = 'Processing...'}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.darkCardBackground,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.darkCardBorder, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  radius: 18,
                  color: AppColors.primaryPeach,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
