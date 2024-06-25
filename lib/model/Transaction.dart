import 'package:email_credit_tracker/Constants.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Transaction.g.dart';

@JsonSerializable()
class Transaction {
  Transaction(
      this.amount, this.label, this.account, this.note, this.timestamp) {
    transactionId = "${label!}_${timestamp!}";
  }

  int? amount;
  String? label;
  String? note;
  String? account;

  @JsonKey(defaultValue: Constants.UNDEFINED_CATEGORY)
  String? category = Constants.UNDEFINED_CATEGORY;
  
  int? timestamp;
  String? transactionId;

  @override
  String toString() {
    return "${label} ${amount} ${DateTime.fromMillisecondsSinceEpoch(timestamp!).toString()}";
  }

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
