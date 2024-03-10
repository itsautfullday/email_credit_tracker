import 'package:email_credit_tracker/model/AutoIngestionManager.dart';
import 'package:email_credit_tracker/model/GmailManager.dart';

class IntroductionController {
  void signInWithGoogle() async {
    await GmailManager.instance.signIn();
    AutoIngestionManager.instance.manager = GmailManager.instance;
    AutoIngestionManager.instance.ingestTransactionsFromEmail();
  }
}
