import 'package:email_credit_tracker/model/AutoIngestionManager.dart';
import 'package:flutter/material.dart';
import 'package:email_credit_tracker/model/GmailManager.dart';

class IntroductionController extends ChangeNotifier{
  void signInWithGoogle() async {
    await GmailManager.instance.signIn();
  }
}
