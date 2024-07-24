//More things needed : Analysis view : Switch for daily and monthly
//Rebuild downstream via provider
// 2 tables :    Account table and category table, percentage splits and top transactions
// see if we can fetch more than the mails from last 100!

import 'dart:convert';

import 'package:email_credit_tracker/controller/AnalysisController.dart';
import 'package:email_credit_tracker/controller/IntroductionController.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnalysisView extends StatelessWidget {
  IntroductionController controller = new IntroductionController();

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
        body: Column(children: [
      AnalysisDateRange(),
      ChangeNotifierProvider(
          create: (context) => AnalysisDateRangeChangeNotifier.instance,
          child: AnalysisTablesBlock())
    ]));
  }
}

class AnalysisDateRange extends StatelessWidget {
  DateTime endDate = AnalysisController.instance.start;
  DateTime startDate = AnalysisController.instance.end;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [DateText(startDate, "From"), DateText(endDate, "To")],
    );
  }
}

class DateText extends StatefulWidget {
  DateTime date;
  String annotation;
  DateText(this.date, this.annotation);

  @override
  DateTextState createState() => DateTextState(date, annotation);
}

class DateTextState extends State<DateText> {
  DateTime date;
  String annotation;
  DateTextState(this.date, this.annotation);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        if (newDate != null) {
          this.date = newDate;
          setState(() {});
        }
      },
      child: SizedBox(
        child: Column(
          children: [
            Text(this.annotation),
            Text(DateFormat('dd/MM/yy').format(date))
          ],
        ),
      ),
    );
  }
}

class AnalysisTablesBlock extends StatefulWidget {
  AnalysisTablesBlockState createState() => AnalysisTablesBlockState();
}

class AnalysisTablesBlockState extends State<AnalysisTablesBlock> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalysisDateRangeChangeNotifier>(
      builder: (context, value, child) {
        return Column(
          children: [
            AnalysisTable(AccountAnalysisTableFiller()),
            AnalysisTable(CategoryAnalysis())
          ],
        );
      },
    );
  }
}

class AnalysisTable extends StatelessWidget {
  AnalysisTableFiller tableData;
  AnalysisTable(this.tableData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tableData.getAnalysisTitle()),
        Text(tableData.getTotalSpend().toString()),
        Text(jsonEncode(tableData.getUniqueKeysToTotals()))
      ],
    );
  }
}

//Rough ideas for Analysis view:

// First thing should be a total spend
// Followed by 2 tables each with a header and 3 colums : Max transaction, Total spent, % of total spent
// 1 for Categories, the other for accounts
// Can create some parent child classes for both of these analysis tables and add them in a for loop? - yea
