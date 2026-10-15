import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../controllers/transaction_controller.dart';

class AddEditTransactionDialog extends StatefulWidget {
  final TransactionModel? transaction;
  final String initialType;

  const AddEditTransactionDialog({
    super.key,
    this.transaction,
    this.initialType = 'expense',
  });

  @override
  State<AddEditTransactionDialog> createState() => _AddEditTransactionDialogState();
}

class _AddEditTransactionDialogState extends State<AddEditTransactionDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  late String _type;
  late String _category;
  late String _paymentMethod;
  late DateTime _selectedDate;

  final List<String> _paymentMethods = ['Card', 'UPI', 'Cash', 'Net Banking', 'Transfer'];

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _type = txn?.type ?? widget.initialType;
    _category = txn?.category ?? 'Bills & Utilities';
    _paymentMethod = txn?.paymentMethod ?? 'Card';
    _selectedDate = txn?.dateTime ?? DateTime.now();

    if (txn != null) {
      _amountController.text = txn.amount.toStringAsFixed(2);
      _descriptionController.text = txn.description;
      _notesController.text = txn.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCardBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark, size: 22),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Expense / Income Segmented Pills
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'expense'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'expense' ? AppColors.primaryPeach : AppColors.darkCardSecondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Expense',
                            style: TextStyle(
                              color: _type == 'expense' ? AppColors.darkBackground : AppColors.textSecondaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _type = 'income'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _type == 'income' ? AppColors.incomeGreen : AppColors.darkCardSecondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: _type == 'income' ? AppColors.darkBackground : AppColors.textSecondaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount Input Field
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '${controller.currencySymbol.value} ',
                  prefixStyle: const TextStyle(color: AppColors.primaryPeach, fontSize: 24, fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                  filled: true,
                  fillColor: AppColors.darkCardSecondary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              // Description Field
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  labelText: 'Description (Title)',
                  hintText: 'e.g. Coffee, Supermarket, Salary',
                  hintStyle: const TextStyle(color: AppColors.textMutedDark),
                  labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                  filled: true,
                  fillColor: AppColors.darkCardSecondary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),

              // Category & Payment Row (Fixed Overflow with isExpanded and contentPadding)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: controller.categories.any((c) => c.name == _category) ? _category : 'Bills & Utilities',
                      dropdownColor: AppColors.darkCardSecondary,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                        filled: true,
                        fillColor: AppColors.darkCardSecondary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      items: controller.categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat.name,
                          child: Text(cat.name, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _category = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _paymentMethod,
                      dropdownColor: AppColors.darkCardSecondary,
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        labelText: 'Payment',
                        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
                        filled: true,
                        fillColor: AppColors.darkCardSecondary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                      items: _paymentMethods.map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text(m, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _paymentMethod = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date Picker Row
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primaryPeach,
                            onPrimary: AppColors.darkBackground,
                            surface: AppColors.darkCardBackground,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.darkCardSecondary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: AppColors.primaryPeach, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('E, MMM dd, yyyy').format(_selectedDate),
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryDark, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Save / Update Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final amountText = _amountController.text.trim();
                    if (amountText.isEmpty) return;
                    final amt = double.tryParse(amountText) ?? 0.0;
                    if (amt <= 0) return;

                    final desc = _descriptionController.text.trim();

                    if (widget.transaction == null) {
                      await controller.addTransaction(
                        amount: amt,
                        type: _type,
                        category: _category,
                        dateTime: _selectedDate,
                        paymentMethod: _paymentMethod,
                        description: desc.isEmpty ? _category : desc,
                        notes: _notesController.text.trim(),
                      );
                    } else {
                      final updated = widget.transaction!.copyWith(
                        amount: amt,
                        type: _type,
                        category: _category,
                        paymentMethod: _paymentMethod,
                        description: desc.isEmpty ? _category : desc,
                        notes: _notesController.text.trim(),
                      );
                      await controller.updateTransaction(updated);
                    }

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPeach,
                    foregroundColor: AppColors.darkBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 2,
                  ),
                  child: Text(
                    widget.transaction == null ? 'Save Transaction' : 'Update Transaction',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
