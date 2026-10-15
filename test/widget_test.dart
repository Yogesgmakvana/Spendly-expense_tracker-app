import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/models/transaction_model.dart';

void main() {
  test('Spendly Model Smoke Test', () {
    final txn = TransactionModel(
      id: '1',
      amount: 100.0,
      type: 'expense',
      category: 'Food',
      dateTime: DateTime.now(),
      description: 'Test',
    );
    expect(txn.amount, 100.0);
    expect(txn.isExpense, true);
  });
}
