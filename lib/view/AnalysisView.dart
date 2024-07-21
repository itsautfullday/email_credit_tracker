//More things needed : Analysis view : Switch for daily and monthly
//Rebuild downstream via provider
// 2 tables :    Account table and category table, percentage splits and top transactions
// see if we can fetch more than the mails from last 100!

import 'package:email_credit_tracker/controller/AnalysisController.dart';
import 'package:email_credit_tracker/controller/IntroductionController.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AnalysisView extends StatelessWidget {
  IntroductionController controller = new IntroductionController();

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
        body: Column(
      children: [AnanlysisDateRangePicker()],
    ));
  }
}

class AnanlysisDateRangePicker extends StatefulWidget {
  AnalysisDateRangePickerState createState() => AnalysisDateRangePickerState();
}

class AnalysisDateRangePickerState extends State<AnanlysisDateRangePicker> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
        print("Checking _selectedDate " + _selectedDate);
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
        print("Checking _dateCount " + _dateCount);
      } else {
        _rangeCount = args.value.length.toString();
        print("Checking _rangeCount " + _rangeCount);
      }
    });
  }

  Widget build(BuildContext context) {
    return SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(AnalysisController.instance.start,
            AnalysisController.instance.end));
  }
}


//Rough ideas for Analysis view:
// Have a from date, to date and a range picker
// First thing should be a total spend
// Followed by 2 tables each with a header and 3 colums : Max transaction, Total spent, % of total spent
// 1 for Categories, the other for accounts
// Can create some parent child classes for both of these analysis tables and add them in a for loop? - yea


