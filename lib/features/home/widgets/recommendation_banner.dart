import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class RecommendationBanner extends StatelessWidget {
  final VoidCallback onSetBudget;

  const RecommendationBanner({
    super.key,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF11424A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPeach.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: AppColors.primaryPeach,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Considering your recent transactions, it's advisable to limit your spending.",
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: onSetBudget,
                  child: const Text(
                    "Set new budget rules",
                    style: TextStyle(
                      color: AppColors.primaryPeach,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
