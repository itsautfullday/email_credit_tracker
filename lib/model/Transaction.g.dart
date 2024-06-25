// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      json['amount'] as int?,
      json['label'] as String?,
      json['account'] as String?,
      json['note'] as String?,
      json['timestamp'] as int?,
    )
      ..category = json['category'] as String? ?? 'undefined_category'
      ..transactionId = json['transactionId'] as String?;

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'label': instance.label,
      'note': instance.note,
      'account': instance.account,
      'category': instance.category,
      'timestamp': instance.timestamp,
      'transactionId': instance.transactionId,
    };
