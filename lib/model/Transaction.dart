import 'package:json_annotation/json_annotation.dart';
part  'Transaction.g.dart';

@JsonSerializable()
class Transaction {
  Transaction(this.amount, this.label, this.account, this.note, this.timestamp);

  int? amount;
  String? label;
  String? note;
  String? account;
  int? timestamp;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
