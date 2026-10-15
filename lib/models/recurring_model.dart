class RecurringModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String frequency; // 'daily', 'weekly', 'monthly', 'yearly'
  final DateTime dueDate;
  final bool isPaid;
  final String type; // 'expense' or 'income'
  final String notes;

  RecurringModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.frequency,
    required this.dueDate,
    this.isPaid = false,
    this.type = 'expense',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'frequency': frequency,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid ? 1 : 0,
      'type': type,
      'notes': notes,
    };
  }

  factory RecurringModel.fromMap(Map<String, dynamic> map) {
    return RecurringModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] ?? 'Bills',
      frequency: map['frequency'] ?? 'monthly',
      dueDate: DateTime.tryParse(map['dueDate'] ?? '') ?? DateTime.now(),
      isPaid: map['isPaid'] == 1,
      type: map['type'] ?? 'expense',
      notes: map['notes'] ?? '',
    );
  }

  RecurringModel copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    String? frequency,
    DateTime? dueDate,
    bool? isPaid,
    String? type,
    String? notes,
  }) {
    return RecurringModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      dueDate: dueDate ?? this.dueDate,
      isPaid: isPaid ?? this.isPaid,
      type: type ?? this.type,
      notes: notes ?? this.notes,
    );
  }
}
