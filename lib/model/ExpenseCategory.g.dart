// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExpenseCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseCategory _$ExpenseCategoryFromJson(Map<String, dynamic> json) =>
    ExpenseCategory()
      ..assetPath = json['assetPath'] as String?
      ..categoryId = json['categoryId'] as String?
      ..categoryDisplayName = json['categoryDisplayName'] as String?;

Map<String, dynamic> _$ExpenseCategoryToJson(ExpenseCategory instance) =>
    <String, dynamic>{
      'assetPath': instance.assetPath,
      'categoryId': instance.categoryId,
      'categoryDisplayName': instance.categoryDisplayName,
    };
