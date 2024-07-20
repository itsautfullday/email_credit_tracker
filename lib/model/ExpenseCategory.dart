import 'package:json_annotation/json_annotation.dart';
part 'ExpenseCategory.g.dart';

@JsonSerializable()
class ExpenseCategory {
  ExpenseCategory();

  String? assetPath;
  String? categoryId;
  String? categoryName;

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCategoryToJson(this);
}
