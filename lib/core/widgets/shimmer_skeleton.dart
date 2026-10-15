import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/app_colors.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.darkCardBackground,
      highlightColor: AppColors.darkCardSecondary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.darkCardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static Widget dashboardLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerSkeleton(width: double.infinity, height: 180, borderRadius: 24),
        const SizedBox(height: 20),
        const ShimmerSkeleton(width: double.infinity, height: 80, borderRadius: 20),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 90, borderRadius: 20)),
            SizedBox(width: 14),
            Expanded(child: ShimmerSkeleton(width: double.infinity, height: 90, borderRadius: 20)),
          ],
        ),
        const SizedBox(height: 24),
        const ShimmerSkeleton(width: double.infinity, height: 110, borderRadius: 20),
      ],
    );
  }

  static Widget listLoading() {
    return Column(
      children: List.generate(4, (i) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: ShimmerSkeleton(width: double.infinity, height: 72, borderRadius: 18),
        );
      }),
    );
  }
}
