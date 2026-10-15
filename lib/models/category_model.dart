class CategoryModel {
  final String id;
  final String name;
  final int iconCode;
  final String colorHex;
  final String type; // 'expense' or 'income'
  final bool isCustom;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.colorHex,
    required this.type,
    this.isCustom = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'colorHex': colorHex,
      'type': type,
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      iconCode: map['iconCode'] ?? 58284, // Default Material Icon code
      colorHex: map['colorHex'] ?? '#4EBA92',
      type: map['type'] ?? 'expense',
      isCustom: map['isCustom'] == 1,
    );
  }

  static List<CategoryModel> get defaultCategories => [
    CategoryModel(id: 'food', name: 'Food & Dining', iconCode: 0xe532, colorHex: '#FF8A65', type: 'expense'),
    CategoryModel(id: 'transport', name: 'Transport', iconCode: 0xe1d5, colorHex: '#4FC3F7', type: 'expense'),
    CategoryModel(id: 'shopping', name: 'Shopping', iconCode: 0xe59c, colorHex: '#EC407A', type: 'expense'),
    CategoryModel(id: 'rent', name: 'Rent & Housing', iconCode: 0xe318, colorHex: '#AB47BC', type: 'expense'),
    CategoryModel(id: 'bills', name: 'Bills & Utilities', iconCode: 0xe57f, colorHex: '#FFB74D', type: 'expense'),
    CategoryModel(id: 'health', name: 'Health & Medical', iconCode: 0xe3d9, colorHex: '#EF5350', type: 'expense'),
    CategoryModel(id: 'education', name: 'Education', iconCode: 0xe500, colorHex: '#5C6BC0', type: 'expense'),
    CategoryModel(id: 'entertainment', name: 'Entertainment', iconCode: 0xe405, colorHex: '#26A69A', type: 'expense'),
    CategoryModel(id: 'salary', name: 'Salary', iconCode: 0xe0b2, colorHex: '#66BB6A', type: 'income'),
    CategoryModel(id: 'freelance', name: 'Freelance Income', iconCode: 0xe6df, colorHex: '#26C6DA', type: 'income'),
    CategoryModel(id: 'investments', name: 'Investments', iconCode: 0xe8e8, colorHex: '#7E57C2', type: 'income'),
    CategoryModel(id: 'other', name: 'Other', iconCode: 0xe88a, colorHex: '#78909C', type: 'expense'),
  ];
}
