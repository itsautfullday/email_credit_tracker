import 'package:email_credit_tracker/controller/TransactionViewController.dart';
import 'package:email_credit_tracker/model/ExpenseCategory.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:email_credit_tracker/view/TransactionView/TransactionRow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/Transaction.dart';
import '../CommonWidgets/DottedButton.dart';

//Stuff I want to accomplish -
// 3. Add refresh button asset and ad the google email read Flow

class TransactionView extends StatelessWidget {
  TransactionView({super.key});
  @override
  Widget build(BuildContext context) {
    //TODO: In your notes take down the purpoose of the scaffold and Material App and BuildContext ka defintiions and use cases
    return ViewScaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topCenter,
        child: TransactionGrid(),
      ),
      bottomNavigationBar: ActionButtonRow(),
    );
  }
}

class ActionButtonRow extends StatelessWidget {
  final String addAsset = "";
  final String refreshAsset = "";
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

            return ExpensesList(value.updatedTransactions);
          },
        ));
  }
}

class ExpensesList extends StatelessWidget {
  final List<Transaction> transactions;
  ExpensesList(this.transactions);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionRow(transactions[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }
}
