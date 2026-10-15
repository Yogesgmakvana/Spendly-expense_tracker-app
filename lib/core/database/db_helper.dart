import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/budget_model.dart';
import '../../models/recurring_model.dart';
import '../../models/savings_goal_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'spendly_v1.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        paymentMethod TEXT NOT NULL,
        description TEXT,
        notes TEXT,
        receiptPath TEXT,
        tags TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        iconCode INTEGER NOT NULL,
        colorHex TEXT NOT NULL,
        type TEXT NOT NULL,
        isCustom INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        category TEXT NOT NULL,
        monthlyLimit REAL NOT NULL,
        warningThreshold REAL NOT NULL DEFAULT 0.8,
        monthYear TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE recurring (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        frequency TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        isPaid INTEGER NOT NULL DEFAULT 0,
        type TEXT NOT NULL DEFAULT 'expense',
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE savings_goals (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentSaved REAL NOT NULL DEFAULT 0.0,
        targetDate TEXT NOT NULL,
        notes TEXT,
        iconCode INTEGER NOT NULL
      )
    ''');

    // Populate default categories
    final batch = db.batch();
    for (final cat in CategoryModel.defaultCategories) {
      batch.insert('categories', cat.toMap());
    }

    // Populate initial realistic sample data matching reference UI
    final uuid = const Uuid();
    final now = DateTime.now();

    // Sample Recurring Bills (Phone 2 in UI)
    final sampleBills = [
      RecurringModel(
        id: uuid.v4(),
        title: 'Paylater Monthly Bill',
        amount: 350.00,
        category: 'Bills & Utilities',
        frequency: 'monthly',
        dueDate: now.add(const Duration(days: 3)),
        type: 'expense',
      ),
      RecurringModel(
        id: uuid.v4(),
        title: 'Giant Mall Shopping',
        amount: 500.00,
        category: 'Shopping',
        frequency: 'monthly',
        dueDate: now.add(const Duration(days: 7)),
        type: 'expense',
      ),
      RecurringModel(
        id: uuid.v4(),
        title: 'Rent & Housing',
        amount: 355.00,
        category: 'Rent & Housing',
        frequency: 'monthly',
        dueDate: now.add(const Duration(days: 12)),
        type: 'expense',
      ),
    ];

    for (final bill in sampleBills) {
      batch.insert('recurring', bill.toMap());
    }

    // Sample Transactions (Phone 1 & Phone 2 in UI)
    final sampleTxns = [
      TransactionModel(
        id: uuid.v4(),
        amount: 180.75,
        type: 'expense',
        category: 'Bills & Utilities',
        dateTime: now,
        paymentMethod: 'Card',
        description: 'Paylater Nov 2023',
      ),
      TransactionModel(
        id: uuid.v4(),
        amount: 22.50,
        type: 'expense',
        category: 'Food & Dining',
        dateTime: now,
        paymentMethod: 'Card',
        description: 'Mirrage Coffee',
      ),
      TransactionModel(
        id: uuid.v4(),
        amount: 50.00,
        type: 'expense',
        category: 'Transport',
        dateTime: now.subtract(const Duration(days: 1)),
        paymentMethod: 'UPI',
        description: 'Transfer to Andria A. Miracle',
      ),
      TransactionModel(
        id: uuid.v4(),
        amount: 1200.00,
        type: 'income',
        category: 'Salary',
        dateTime: now.subtract(const Duration(days: 5)),
        paymentMethod: 'Transfer',
        description: 'Monthly Salary Deposit',
      ),
      TransactionModel(
        id: uuid.v4(),
        amount: 150.00,
        type: 'expense',
        category: 'Shopping',
        dateTime: now.subtract(const Duration(days: 2)),
        paymentMethod: 'Card',
        description: 'Supermarket Grocery',
      ),
      TransactionModel(
        id: uuid.v4(),
        amount: 300.00,
        type: 'income',
        category: 'Freelance Income',
        dateTime: now.subtract(const Duration(days: 3)),
        paymentMethod: 'UPI',
        description: 'Design Project Milestone',
      ),
    ];

    for (final txn in sampleTxns) {
      batch.insert('transactions', txn.toMap());
    }

    // Sample Overall Budget
    batch.insert(
      'budgets',
      BudgetModel(
        id: uuid.v4(),
        category: 'Overall',
        monthlyLimit: 1500.0,
        warningThreshold: 0.8,
        monthYear: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      ).toMap(),
    );

    // Sample Savings Goal
    batch.insert(
      'savings_goals',
      SavingsGoalModel(
        id: uuid.v4(),
        title: 'Emergency Reserve Fund',
        targetAmount: 5000.0,
        currentSaved: 1850.0,
        targetDate: now.add(const Duration(days: 180)),
        notes: 'Targeting 3 months of basic living costs',
      ).toMap(),
    );

    await batch.commit();
  }

  // --- Transactions Operations ---
  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;
    final maps = await db.query('transactions', orderBy: 'dateTime DESC');
    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<int> insertTransaction(TransactionModel txn) async {
    final db = await database;
    return await db.insert('transactions', txn.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTransaction(TransactionModel txn) async {
    final db = await database;
    return await db.update('transactions', txn.toMap(), where: 'id = ?', whereArgs: [txn.id]);
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // --- Categories Operations ---
  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  Future<int> insertCategory(CategoryModel cat) async {
    final db = await database;
    return await db.insert('categories', cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // --- Budgets Operations ---
  Future<List<BudgetModel>> getBudgets() async {
    final db = await database;
    final maps = await db.query('budgets');
    return maps.map((m) => BudgetModel.fromMap(m)).toList();
  }

  Future<int> saveBudget(BudgetModel budget) async {
    final db = await database;
    return await db.insert('budgets', budget.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteBudget(String id) async {
    final db = await database;
    return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
  }

  // --- Recurring Operations ---
  Future<List<RecurringModel>> getRecurring() async {
    final db = await database;
    final maps = await db.query('recurring', orderBy: 'dueDate ASC');
    return maps.map((m) => RecurringModel.fromMap(m)).toList();
  }

  Future<int> saveRecurring(RecurringModel item) async {
    final db = await database;
    return await db.insert('recurring', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteRecurring(String id) async {
    final db = await database;
    return await db.delete('recurring', where: 'id = ?', whereArgs: [id]);
  }

  // --- Savings Goals Operations ---
  Future<List<SavingsGoalModel>> getSavingsGoals() async {
    final db = await database;
    final maps = await db.query('savings_goals');
    return maps.map((m) => SavingsGoalModel.fromMap(m)).toList();
  }

  Future<int> saveSavingsGoal(SavingsGoalModel goal) async {
    final db = await database;
    return await db.insert('savings_goals', goal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteSavingsGoal(String id) async {
    final db = await database;
    return await db.delete('savings_goals', where: 'id = ?', whereArgs: [id]);
  }

  // Clear Database
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('transactions');
    await db.delete('budgets');
    await db.delete('recurring');
    await db.delete('savings_goals');
  }
}
