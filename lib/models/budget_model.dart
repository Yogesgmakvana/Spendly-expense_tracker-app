class BudgetModel {
  final String id;
  final String category;
  final double monthlyLimit;
  final double warningThreshold; // e.g. 0.8 for 80%
  final String monthYear; // e.g. "2023-11" or "Overall"

  BudgetModel({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    this.warningThreshold = 0.8,
    required this.monthYear,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'monthlyLimit': monthlyLimit,
      'warningThreshold': warningThreshold,
      'monthYear': monthYear,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] ?? '',
      category: map['category'] ?? 'Overall',
      monthlyLimit: (map['monthlyLimit'] as num).toDouble(),
      warningThreshold: (map['warningThreshold'] as num?)?.toDouble() ?? 0.8,
      monthYear: map['monthYear'] ?? '',
    );
  }

  BudgetModel copyWith({
    String? id,
    String? category,
    double? monthlyLimit,
    double? warningThreshold,
    String? monthYear,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      monthYear: monthYear ?? this.monthYear,
    );
  }
}
