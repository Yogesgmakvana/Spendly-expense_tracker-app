class SavingsGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double currentSaved;
  final DateTime targetDate;
  final String notes;
  final int iconCode;

  SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentSaved = 0.0,
    required this.targetDate,
    this.notes = '',
    this.iconCode = 0xe58b, // Savings / Monitization icon
  });

  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    final ratio = currentSaved / targetAmount;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  double get remainingAmount {
    final diff = targetAmount - currentSaved;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentSaved': currentSaved,
      'targetDate': targetDate.toIso8601String(),
      'notes': notes,
      'iconCode': iconCode,
    };
  }

  factory SavingsGoalModel.fromMap(Map<String, dynamic> map) {
    return SavingsGoalModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentSaved: (map['currentSaved'] as num?)?.toDouble() ?? 0.0,
      targetDate: DateTime.tryParse(map['targetDate'] ?? '') ?? DateTime.now(),
      notes: map['notes'] ?? '',
      iconCode: map['iconCode'] ?? 0xe58b,
    );
  }

  SavingsGoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentSaved,
    DateTime? targetDate,
    String? notes,
    int? iconCode,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentSaved: currentSaved ?? this.currentSaved,
      targetDate: targetDate ?? this.targetDate,
      notes: notes ?? this.notes,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
