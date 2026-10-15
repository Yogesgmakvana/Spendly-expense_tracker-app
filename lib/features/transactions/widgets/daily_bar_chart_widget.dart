import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class DailyBarChartWidget extends StatelessWidget {
  final Map<int, double> weeklyData; // 1: Mon, 2: Tue... 7: Sun
  final String currencySymbol;

  const DailyBarChartWidget({
    super.key,
    required this.weeklyData,
    this.currencySymbol = '₹',
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    double maxVal = 100;
    for (final val in weeklyData.values) {
      if (val > maxVal) maxVal = val;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal * 1.15,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.darkCardSecondary,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '$currencySymbol${rod.toY.toStringAsFixed(0)}',
                        const TextStyle(
                          color: AppColors.primaryPeach,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: maxVal / 4 > 0 ? maxVal / 4 : 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: AppColors.textMutedDark,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[idx],
                              style: const TextStyle(
                                color: AppColors.textSecondaryDark,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxVal / 4 > 0 ? maxVal / 4 : 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white10,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final amount = weeklyData[i + 1] ?? 0.0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: amount,
                        color: AppColors.primaryPeach,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: maxVal,
                          color: AppColors.darkCardSecondary,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
