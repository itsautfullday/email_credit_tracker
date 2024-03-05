import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'EmailContent.dart';

class HDFCTransactionManager extends BankTransactionsManager {
  EmailContent emailContent;

  HDFCTransactionManager(this.emailContent):super(emailContent);

  bool isUPITransaction() {
    return false;
  }

  bool isCreditCardTransaction() {
    return false;
  }

  Transaction parseUPITransactionFromEmail(){
    return Transaction(amount, label, account, note, timestamp)
  }
  Transaction parseCreditCardTransactionFromEmail(){
    return Transaction(amount, label, account, note, timestamp)
  }
}
