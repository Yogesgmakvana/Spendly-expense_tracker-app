import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../models/transaction_model.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final String currencySymbol;
  final bool hideBalance;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.currencySymbol = '₹',
    this.hideBalance = false,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.isExpense;
    final iconColor = isExpense ? AppColors.primaryPeach : AppColors.incomeGreen;
    final amountColor = isExpense ? AppColors.textPrimaryDark : AppColors.incomeGreen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          title: Text(
            transaction.description.isNotEmpty ? transaction.description : transaction.category,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            DateFormatter.formatShort(transaction.dateTime),
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 12,
            ),
          ),
          trailing: Text(
            isExpense
                ? '-${CurrencyFormatter.format(transaction.amount, currencySymbol: currencySymbol, hideBalance: hideBalance)}'
                : '+${CurrencyFormatter.format(transaction.amount, currencySymbol: currencySymbol, hideBalance: hideBalance)}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
