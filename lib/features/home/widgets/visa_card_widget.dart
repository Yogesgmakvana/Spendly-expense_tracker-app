import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../transactions/views/add_edit_transaction_dialog.dart';

class VisaCardWidget extends StatelessWidget {
  final double balance;
  final double netChange;
  final bool hideBalance;
  final String currencySymbol;
  final VoidCallback onToggleHide;

  const VisaCardWidget({
    super.key,
    required this.balance,
    required this.netChange,
    required this.hideBalance,
    required this.currencySymbol,
    required this.onToggleHide,
  });

  @override
  Widget build(BuildContext context) {
    final displayBalance = balance > 0 ? balance : 2222.83;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.visaCardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Your Balance',
                    style: TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onToggleHide,
                    child: Icon(
                      hideBalance ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondaryDark,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(displayBalance, currencySymbol: currencySymbol, hideBalance: hideBalance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.expenseRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.south_west_rounded,
                      color: AppColors.expenseRed,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '-${CurrencyFormatter.format(25.55, currencySymbol: currencySymbol)}',
                      style: const TextStyle(
                        color: AppColors.expenseRed,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    const AddEditTransactionDialog(initialType: 'income'),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Top-Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
