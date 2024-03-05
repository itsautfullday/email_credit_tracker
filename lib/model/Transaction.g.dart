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
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'label': instance.label,
      'note': instance.note,
      'account': instance.account,
      'timestamp': instance.timestamp,
    };
