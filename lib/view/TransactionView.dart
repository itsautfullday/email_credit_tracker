import 'package:dotted_border/dotted_border.dart';
import 'package:email_credit_tracker/controller/TransactionCreateUpdateController.dart';
import 'package:email_credit_tracker/controller/TransactionViewController.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:provider/provider.dart';

import '../model/Transaction.dart';

import 'CommonWidgets/DottedButton.dart';
import 'TransactionCreateUpdate.dart';

//Stuff I want to accomplish -
// 2.5 Add the add transaction routing
// 2.75  and back buttons routing?

// 3. Add refresh button asset and ad the google email read Flow

class TransactionView extends StatelessWidget {
  TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: In your notes take down the purpoose of the scaffold and Material App and BuildContext ka defintiions and use cases
    return ViewScaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(children: [TransactionGrid(), ActionButtonRow()]),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreateUpdateTransaction(transaction: null)),
            );
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
  List<DataRow> fetchTransactionsDataRow(List<Transaction> transactions) {
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
    return ChangeNotifierProvider(
        create: (context) => TransactionViewController.instance,
        child: Consumer<TransactionViewController>(
          builder: (context, value, child) {
            if (value.updatedTransactions.isEmpty) {
              return Text('Loading your transactions...',
                  style: Theme.of(context).textTheme.bodyMedium);
            }

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
            ], rows: fetchTransactionsDataRow(value.updatedTransactions));
          },
        ));
  }
}
