import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/controller/IntroductionController.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import 'CommonWidgets/DottedButton.dart';

class IntroductionView extends StatelessWidget {
  IntroductionController controller = new IntroductionController();
  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Constants.INTRODUCTORY_TEXT,
                style: Theme.of(context).textTheme.titleLarge),
            DottedButton(
                text: "Login in with Google",
                onPressed: () {
                  controller.signInWithGoogle();
                }),
          ],
        ),
      )),
    );
  }
}
