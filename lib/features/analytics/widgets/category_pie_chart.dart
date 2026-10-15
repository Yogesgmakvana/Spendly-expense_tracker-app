import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, double> categoryData;
  final double totalExpense;
  final String currencySymbol;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.totalExpense,
    this.currencySymbol = '₹',
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  final List<Color> colors = const [
    AppColors.primaryPeach,
    Color(0xFF4FC3F7),
    Color(0xFFEC407A),
    Color(0xFFAB47BC),
    Color(0xFFFFB74D),
    Color(0xFF26A69A),
    Color(0xFF5C6BC0),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.categoryData.isEmpty || widget.totalExpense <= 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text('No expense data to analyze', style: TextStyle(color: AppColors.textSecondaryDark)),
      );
    }

    final entries = widget.categoryData.entries.toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 4,
                centerSpaceRadius: 50,
                sections: List.generate(entries.length, (i) {
                  final isTouched = i == touchedIndex;
                  final radius = isTouched ? 35.0 : 28.0;
                  final entry = entries[i];
                  final color = colors[i % colors.length];
                  final percent = ((entry.value / widget.totalExpense) * 100).toStringAsFixed(0);

                  return PieChartSectionData(
                    color: color,
                    value: entry.value,
                    title: '$percent%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: isTouched ? 14 : 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(entries.length, (i) {
              final entry = entries[i];
              final color = colors[i % colors.length];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text(
                    '${entry.key} (${widget.currencySymbol}${entry.value.toStringAsFixed(0)})',
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
