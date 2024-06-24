import 'ExpenseCategory.dart';

class ExpenseCategoryManager {
  Map<String, ExpenseCategory> categoryMap = Map();
  // loads a category json from assets into category map
  void loadCategoryInfo() {}

  ExpenseCategory getCategory(String categoryId) {
    if (categoryMap.containsKey(categoryId)) {
      return categoryMap[categoryId]!;
    }
    throw Exception('Unknown category trying to be fetched! $categoryId');
  }
}