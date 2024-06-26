import 'package:email_credit_tracker/model/ExpenseCategory.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:flutter/material.dart';
import '../../controller/TransactionViewController.dart';
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
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          TransactionViewController.instance
              .editTransaction(context, transaction!);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoryImage(categoryDetails),
            TransactionDetails(transaction!),
            ExpenseDetails(transaction!)
          ],
        ));
  }
}

class CategoryImage extends StatelessWidget {
  final ExpenseCategory categoryDetails;
  CategoryImage(this.categoryDetails);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Image.asset(
              categoryDetails.assetPath!,
              semanticLabel: categoryDetails.assetPath!,
            ))
      ],
    );
  }
}

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  TransactionDetails(this.transaction);

  @override
  Widget build(BuildContext context) {
    String label = transaction.label!;
    if (label.length > 22) {
      label = label.substring(0, 22) + "..";
    }

    return Container(
      width: 260,
      child: Column(
        children: [
          Text(
            label,
          ),
          Text(
            transaction.account!,
            textScaleFactor: 0.5,
          )
        ],
      ),
    );
  }
}

class ExpenseDetails extends StatelessWidget {
  final Transaction transaction;
  ExpenseDetails(this.transaction);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: Text(
        transaction.amount!.toString(),
        textScaleFactor: 0.75,
      ),
    );
  }
}
