import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/controller/IntroductionController.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'CommonWidgets/DottedButton.dart';

class IntroductionView extends StatelessWidget {
  IntroductionController controller = new IntroductionController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Constants.APP_NAME,
                style: Theme.of(context).textTheme.titleLarge),
            Text(Constants.INTRODUCTORY_TEXT,
                style: Theme.of(context).textTheme.titleLarge),
            DottedButton(
                text: "Login in with Google",
                onPressed: () {
                  controller.signInWithGoogle();
                }),
            DottedButton(
                text: "Fetch Email Data",
                onPressed: () {
                  controller.debugIngestTransactionsFromEmail();
                })
          ],
        ),
      )),
    );
  }
}
