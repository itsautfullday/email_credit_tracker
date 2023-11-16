import 'dart:core';
import 'package:json_annotation/json_annotation.dart';

enum DebitType { cash, credit_card }


class Debit {
  DateTime transactionTime;
  String name;

  int amount;
  DebitType type;
  String? description;

  String get debitId {
    return [transactionTime.toIso8601String() ,name ,amount.toString() ,type.toString()].join('_');
  }

  Debit(
      {required this.transactionTime,
      required this.name,
      required this.type,
      required this.amount,
      this.description});
}
