import 'dart:convert';

class TransactionModel {
  final String id;
  final double amount;
  final String type; // 'expense' or 'income'
  final String category;
  final DateTime dateTime;
  final String paymentMethod; // Cash, Card, UPI, Net Banking, Transfer
  final String description;
  final String notes;
  final String? receiptPath;
  final List<String> tags;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.dateTime,
    this.paymentMethod = 'Card',
    required this.description,
    this.notes = '',
    this.receiptPath,
    this.tags = const [],
  });

  bool get isExpense => type.toLowerCase() == 'expense';
  bool get isIncome => type.toLowerCase() == 'income';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'dateTime': dateTime.toIso8601String(),
      'paymentMethod': paymentMethod,
      'description': description,
      'notes': notes,
      'receiptPath': receiptPath,
      'tags': jsonEncode(tags),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    List<String> parsedTags = [];
    if (map['tags'] != null && map['tags'].toString().isNotEmpty) {
      try {
        final decoded = jsonDecode(map['tags']);
        if (decoded is List) {
          parsedTags = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        parsedTags = [];
      }
    }

    return TransactionModel(
      id: map['id'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] ?? 'expense',
      category: map['category'] ?? 'Other',
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? 'Card',
      description: map['description'] ?? '',
      notes: map['notes'] ?? '',
      receiptPath: map['receiptPath'],
      tags: parsedTags,
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? type,
    String? category,
    DateTime? dateTime,
    String? paymentMethod,
    String? description,
    String? notes,
    String? receiptPath,
    List<String>? tags,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      receiptPath: receiptPath ?? this.receiptPath,
      tags: tags ?? this.tags,
    );
  }
}
