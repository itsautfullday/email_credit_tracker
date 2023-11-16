import 'package:expense_manager_client_2/models/data_models/Debit.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DebitsViewScreen extends StatefulWidget {
  @override
  DebitsViewScreenState createState() {
    return DebitsViewScreenState();
  }
}

class DebitsViewScreenState extends State<DebitsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expense manager - Email read',
        home: Scaffold(
          body: Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: DottedBorder(
                color: Colors.green,
                strokeWidth: 1,
                child: DebitMetaTable(),
              )),
        ));
  }
}

class DebitMetaTable extends StatefulWidget {
  @override
  DebitMetaTableState createState() {
    return DebitMetaTableState();
  }
}

class DebitMetaTableState extends State<DebitMetaTable> {
  List<Debit> debitList = [];

  void onTapDaily() {}
  @override
  Widget build(BuildContext context) {
    //TODO In the future this needs to be removed!
    return Column(children: [DebitsViewHeader(onTapDaily, onTapDaily, onTapDaily)]);
  }
}

class DebitsViewHeader extends StatelessWidget {
  Function dayViewTap;
  Function weekViewTap;
  Function monthViewTap;

  DebitsViewHeader(this.dayViewTap, this.weekViewTap, this.monthViewTap);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      DebitViewHeaderButton("Daily", dayViewTap),
      DebitViewHeaderButton("Weekly", dayViewTap),
      DebitViewHeaderButton("Monthly", monthViewTap),
    ]);
  }
}

class DebitViewHeaderButton extends StatelessWidget {
  final String text;
  final Function onClickAction;

  DebitViewHeaderButton(this.text, this.onClickAction);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        child: GestureDetector(
      onTap: onClickAction(),
      child: Text(text),
    ));
  }
}



