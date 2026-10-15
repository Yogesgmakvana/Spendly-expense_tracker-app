import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/models/transaction_model.dart';
import 'package:spendly/models/savings_goal_model.dart';
import 'package:spendly/core/utils/currency_formatter.dart';
import 'package:spendly/core/utils/date_formatter.dart';

void main() {
  group('Spendly Unit Tests', () {
    test('TransactionModel toMap and fromMap serialization', () {
      final now = DateTime.now();
      final txn = TransactionModel(
        id: 't1',
        amount: 180.75,
        type: 'expense',
        category: 'Bills & Utilities',
        dateTime: now,
        description: 'Paylater Nov 2023',
      );

      final map = txn.toMap();
      expect(map['id'], 't1');
      expect(map['amount'], 180.75);

      final reconstructed = TransactionModel.fromMap(map);
      expect(reconstructed.id, 't1');
      expect(reconstructed.amount, 180.75);
      expect(reconstructed.isExpense, true);
    });

    test('CurrencyFormatter formatting and hide balance', () {
      final formattedUSD = CurrencyFormatter.format(29.33, currencySymbol: '\$');
      expect(formattedUSD, '\$29.33');

      final formattedINR = CurrencyFormatter.format(1205.00, currencySymbol: '₹');
      expect(formattedINR, '₹1,205.00');

      final hidden = CurrencyFormatter.format(29.33, hideBalance: true);
      expect(hidden, '••••••');
    });

    test('SavingsGoalModel progress calculation', () {
      final goal = SavingsGoalModel(
        id: 'g1',
        title: 'Emergency Fund',
        targetAmount: 1000.0,
        currentSaved: 500.0,
        targetDate: DateTime.now().add(const Duration(days: 30)),
      );

      expect(goal.progressPercentage, 0.5);
      expect(goal.remainingAmount, 500.0);
    });

    test('DateFormatter formatting', () {
      final date = DateTime(2023, 11, 12);
      final formatted = DateFormatter.formatShort(date);
      expect(formatted, 'Nov 12, 2023');
    });
  });
}
