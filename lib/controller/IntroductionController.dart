import 'package:email_credit_tracker/model/GmailManager.dart';

class IntroductionController {
  void signInWithGoogle() async {
    await GmailManager.instance.signIn();
    GmailManager.instance.getUserMail();
  }
}