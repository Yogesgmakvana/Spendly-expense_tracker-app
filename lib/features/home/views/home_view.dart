import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/shimmer_skeleton.dart';
import '../controllers/home_controller.dart';
import '../widgets/visa_card_widget.dart';
import '../widgets/recommendation_banner.dart';
import '../widgets/active_bills_widget.dart';
import '../../navigation/controllers/navigation_controller.dart';
import '../../notifications/views/notification_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.find<NavigationController>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.refreshDashboard(),
          color: AppColors.primaryPeach,
          backgroundColor: AppColors.darkCardBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Bar with Spendly Logo from Assets and notification bell
                _buildTopAppBar(),
                const SizedBox(height: 20),

                Obx(() {
                  if (controller.isLoading.value) {
                    return ShimmerSkeleton.dashboardLoading();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Visa Card Widget
                      VisaCardWidget(
                        balance: controller.totalBalance.value,
                        netChange: controller.netChange.value,
                        hideBalance: controller.hideBalance.value,
                        currencySymbol: controller.currencySymbol.value,
                        onToggleHide: controller.toggleHideBalance,
                      ),
                      const SizedBox(height: 20),

                      // Recommendation Banner
                      RecommendationBanner(
                        onSetBudget: () => navCtrl.changePage(3),
                      ),
                      const SizedBox(height: 20),

                      // Side by Side Summary Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Bills Due Total',
                              amount: controller.billsDueTotal.value > 0 ? controller.billsDueTotal.value : 5000.00,
                              currencySymbol: controller.currencySymbol.value,
                              onTap: () => navCtrl.changePage(3),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'Expenses Total',
                              amount: controller.totalExpenses.value > 0 ? controller.totalExpenses.value : 403.25,
                              currencySymbol: controller.currencySymbol.value,
                              onTap: () => navCtrl.changePage(1),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Active Bills Carousel
                      ActiveBillsWidget(
                        bills: controller.activeBills.toList(),
                        currencySymbol: controller.currencySymbol.value,
                        onSeeAll: () => navCtrl.changePage(3),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/app_icon.png',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Color(0xFF092B30),
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Spendly',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Get.to(() => const NotificationView());
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkCardBackground,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkCardBorder, width: 1),
            ),
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPeach,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required String currencySymbol,
    required VoidCallback onTap,
  }) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondaryDark,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyFormatter.format(amount, currencySymbol: currencySymbol),
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
