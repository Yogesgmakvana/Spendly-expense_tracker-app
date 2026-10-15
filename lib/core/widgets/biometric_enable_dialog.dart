import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class BiometricEnableDialog extends StatelessWidget {
  final bool isFaceId;
  final VoidCallback onEnable;
  final VoidCallback onMaybeLater;

  const BiometricEnableDialog({
    super.key,
    required this.isFaceId,
    required this.onEnable,
    required this.onMaybeLater,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: AppColors.darkCardBackground,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.darkCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Badge
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.primaryPeach.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isFaceId ? Icons.face_retouching_natural_rounded : Icons.fingerprint_rounded,
                color: AppColors.primaryPeach,
                size: 38,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              isFaceId ? 'Enable Face ID' : 'Enable Fingerprint Lock',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'Would you like to enable ${isFaceId ? "Face ID" : "Fingerprint"} for faster and secure unlock next time?',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Primary Enable Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPeach,
                  foregroundColor: AppColors.darkBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: onEnable,
                child: const Text(
                  'Enable Now',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Secondary Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: onMaybeLater,
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
