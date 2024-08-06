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
          create: (context) => AnalysisDateRangeChangeNotifier(),
          child: AnalysisTablesBlock())
    ]));
  }
}

class AnalysisDateRange extends StatelessWidget {
  DateTime endDate = AnalysisController.instance.end;
  DateTime startDate = AnalysisController.instance.start;

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

          setState(() {
            if (annotation == "From") {
              AnalysisController.instance.start = newDate;
            } else {
              AnalysisController.instance.end = newDate;
            }
          });
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
            SizedBox(height: 10),
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

  List<DataColumn> getDataColumnValues() {
    return [
      DataColumn(label: Text(tableData.getAnalysisKeys())),
      const DataColumn(label: Text('Σ Spends')),
      const DataColumn(label: Text('% Spends'))
    ];
  }

  List<DataRow> getDataRowsForUniqueKeys() {
    List<DataRow> result = [];

    Map<String, int> keysToTotals = tableData.getUniqueKeysToTotals();
    Map<String, double> keysToPercs =
        tableData.getUniqueKeysToPercentageOfTotal();
    keysToTotals.forEach((key, value) {
      result.add(DataRow(cells: [
        DataCell(Text(key)),
        DataCell(Text(value.toString())),
        DataCell(Text(keysToPercs[key].toString()))
      ]));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tableData.getAnalysisTitle()),
        Text("Total Spend : " + tableData.getTotalSpend().toString()),
        DataTable(
          // datatable widget
          columns: getDataColumnValues(),
          rows: getDataRowsForUniqueKeys(),
        )
      ],
    );
  }
}
