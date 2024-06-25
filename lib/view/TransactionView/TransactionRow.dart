import 'package:email_credit_tracker/model/ExpenseCategory.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:flutter/material.dart';
import '../../model/Transaction.dart';

class TransactionRow extends StatelessWidget {
  Transaction? transaction;
  late ExpenseCategory categoryDetails;

  TransactionRow(this.transaction) {
    if (this.transaction == null) {
      print("Transaction null");
    } else if (transaction!.category == null) {
      print("cat null");
    }
    categoryDetails =
        ExpenseCategoryManager.instance.getCategory(transaction!.category!);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoryImage(categoryDetails),
        TransactionDetails(transaction!),
        ExpenseDetails(transaction!)
      ],
    );
  }
}

class CategoryImage extends StatelessWidget {
  final ExpenseCategory categoryDetails;
  CategoryImage(this.categoryDetails);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(categoryDetails.assetPath!,
            semanticLabel: categoryDetails.assetPath!)
      ],
    );
  }
}

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  TransactionDetails(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(transaction.label!), Text(transaction.account!)],
    );
  }
}

class ExpenseDetails extends StatelessWidget {
  final Transaction transaction;
  ExpenseDetails(this.transaction);
  @override
  Widget build(BuildContext context) {
    return Text(transaction.amount!.toString());
  }
}
