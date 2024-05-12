import 'package:dotted_border/dotted_border.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/apigeeregistry/v1.dart';

import '../model/Transaction.dart';

import 'CommonWidgets/DottedButton.dart';

//Stuff I want to accomplish - 
// 4. Add load delay for the app - possibly with a simple Animation
// 2. Add scaffold with header for the app
// 2.5 Add the add transaction routing
// 2.75  and back buttons routing?

// 3. Add refresh button asset and ad the google email read Flow


class TransactionView extends StatelessWidget {
  TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(children: [TransactionGrid()]),
    ));
  }
}

//TODO Add ActionButtonRow
class ActionButtonRow extends StatelessWidget {
  String addAsset = "";
  String refreshAsset = "";
  Widget build(BuildContext context) {
    return Row(
      children: [
        DottedButton(
          text: "+",
          onPressed: () {
            print("Implement add button utkarsh");
          },
        )
      ],
    );
  }
}

class TransactionGrid extends StatefulWidget {
  TransactionGridState createState() => TransactionGridState();
}

class TransactionGridState extends State<TransactionGrid> {
  List<DataRow> fetchTransactionsDataRow() {
    List<Transaction> transactions =
        TransactionsManager.instance.getAllTransactions();
    List<DataRow> result = [];
    transactions.forEach((element) {
      result.add(getDataRowFromTransaction(element));
    });
    return result;
  }

  DataRow getDataRowFromTransaction(Transaction? transaction) {
    return DataRow(cells: [
      DataCell(Text(
        transaction!.label.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      )),
      DataCell(Text(
        transaction.amount.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      )),
      DataCell(Text(
        transaction.account.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(columns: [
      DataColumn(
          label: Text(
        'Label',
        style: Theme.of(context).textTheme.bodyMedium,
      )),
      DataColumn(
          label: Text(
        'Amount',
        style: Theme.of(context).textTheme.bodyMedium,
      )),
      DataColumn(
          label: Text(
        'Account',
        style: Theme.of(context).textTheme.bodyMedium,
      ))
    ], rows: fetchTransactionsDataRow());
  }
}
