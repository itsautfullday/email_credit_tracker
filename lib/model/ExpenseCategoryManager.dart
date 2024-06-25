import 'dart:convert';

import 'package:flutter/services.dart';

import 'ExpenseCategory.dart';

class ExpenseCategoryManager {
  ExpenseCategoryManager._constructor();

  static ExpenseCategoryManager? _instance;
  static ExpenseCategoryManager get instance {
    _instance ??= ExpenseCategoryManager._constructor();
    return _instance!;
  }

  Map<String, ExpenseCategory> categoryMap = Map();
  // loads a category json from assets into category map
  void loadCategoryInfo() async {
    String catJSONString =
        await rootBundle.loadString("assets/json/categories.json");
    Map<String, dynamic> catJSON = jsonDecode(catJSONString);
    catJSON.forEach((key, value) {
      categoryMap[key] = ExpenseCategory.fromJson(value);
    });
  }

  ExpenseCategory getCategory(String categoryId) {
    if (categoryMap.containsKey(categoryId)) {
      return categoryMap[categoryId]!;
    }
    throw Exception('Unknown category trying to be fetched! $categoryId');
  }
}
