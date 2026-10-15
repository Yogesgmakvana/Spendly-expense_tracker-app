import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/recurring_model.dart';
import '../../../core/utils/currency_formatter.dart';

class ActiveBillsWidget extends StatelessWidget {
  final List<RecurringModel> bills;
  final String currencySymbol;
  final VoidCallback onSeeAll;

  const ActiveBillsWidget({
    super.key,
    required this.bills,
    required this.currencySymbol,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Bill',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 110,
          child: bills.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.darkCardBorder, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPeach.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: AppColors.primaryPeach,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ugug',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Text(
                            'Bills',
                            style: TextStyle(color: AppColors.textMutedDark, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.format(5000.00, currencySymbol: currencySymbol),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.darkCardBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.darkCardBorder, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPeach.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.article_outlined,
                                  color: AppColors.primaryPeach,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bill.title,
                                      style: const TextStyle(
                                        color: AppColors.textPrimaryDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      bill.category,
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
                          Text(
                            CurrencyFormatter.format(bill.amount, currencySymbol: currencySymbol),
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
