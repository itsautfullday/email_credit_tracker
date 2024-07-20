//More things needed : Analysis view : Switch for daily and monthly
//Rebuild downstream via provider
// 2 tables :    Account table and category table, percentage splits and top transactions
// see if we can fetch more than the mails from last 100!


import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/controller/IntroductionController.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'CommonWidgets/DottedButton.dart';

class AnalysisView extends StatelessWidget {
  IntroductionController controller = new IntroductionController();

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      body: Column()
    );
  }
}

//Rough ideas for Analysis view:
// Have a from date, to date and a range picker
// First thing should be a total spend
// Followed by 2 tables each with a header and 3 colums : Max transaction, Total spent, % of total spent
// 1 for Categories, the other for accounts
// Can create some parent child classes for both of these analysis tables and add them in a for loop? - yea
//TODO : ADD DELETE TRANSACTION And yea refactor the form class please


