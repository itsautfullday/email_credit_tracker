import 'package:email_credit_tracker/controller/TransactionViewController.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Transaction.dart';
import 'CommonWidgets/DottedButton.dart';

//Stuff I want to accomplish -
// 3. Add refresh button asset and ad the google email read Flow

class TransactionView extends StatelessWidget {
  TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: In your notes take down the purpoose of the scaffold and Material App and BuildContext ka defintiions and use cases
    return ViewScaffold(
        floatingActionButton: ActionButtonRow(),
        body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.topCenter,
          child: TransactionGrid(),
        ));
  }
}

//TODO Add ActionButtonRow
class ActionButtonRow extends StatelessWidget {
  String addAsset = "";
  String refreshAsset = "";
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DottedButton(
            text: "+",
            onPressed: () {
              TransactionViewController.instance.addTransaction(context);
            },
          ),
          DottedButton(
            text: "⟳",
            onPressed: () {
              print("Calling on pressed");
              TransactionViewController.instance.refreshTransactionsFromEmail();
            },
          )
        ],
      ),
    );
  }
}

class TransactionGrid extends StatefulWidget {
  TransactionGridState createState() => TransactionGridState();
}

class TransactionGridState extends State<TransactionGrid> {
  List<DataRow> fetchTransactionsDataRow(
      List<Transaction> transactions, BuildContext context) {
    List<DataRow> result = [];
    transactions.forEach((element) {
      result.add(getDataRowFromTransaction(element, context));
    });
    return result;
  }

  DataRow getDataRowFromTransaction(
      Transaction? transaction, BuildContext context) {
    return DataRow(cells: [
      DataCell(onTap: () {
        TransactionViewController.instance
            .editTransaction(context, transaction);
      },
          Text(
            transaction!.label.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )),
      DataCell(onTap: () {
        TransactionViewController.instance
            .editTransaction(context, transaction);
      },
          Text(
            transaction.amount.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          )),
      DataCell(onTap: () {
        TransactionViewController.instance
            .editTransaction(context, transaction);
      },
          Text(
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
            if (value.shouldShowLoadingTransactionsMessage()) {
              return Text('Loading your transactions...',
                  style: Theme.of(context).textTheme.bodyMedium);
            }

            if (value.shouldShowNoTransactionsMessage()) {
              return Text('Add some transactions!',
                  style: Theme.of(context).textTheme.bodyMedium);
            }

            return TwoDimensionalScrollWidget(
              child: DataTable(
                  columns: [
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
                  ],
                  rows: fetchTransactionsDataRow(
                      value.updatedTransactions, context)),
            );
          },
        ));
  }
}

class TwoDimensionalScrollWidget extends StatelessWidget {
  final Widget child;

  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  TwoDimensionalScrollWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 12.0,
      trackVisibility: true,
      interactive: true,
      controller: _verticalController,
      scrollbarOrientation: ScrollbarOrientation.right,
      thumbVisibility: true,
      child: Scrollbar(
        thickness: 12.0,
        trackVisibility: true,
        interactive: true,
        controller: _horizontalController,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        thumbVisibility: true,
        notificationPredicate: (ScrollNotification notif) => notif.depth == 1,
        child: SingleChildScrollView(
          controller: _verticalController,
          child: SingleChildScrollView(
            primary: false,
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: child,
          ),
        ),
      ),
    );
  }
}
