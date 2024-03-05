import 'package:email_credit_tracker/model/EmailContent.dart';
import 'package:email_credit_tracker/model/Transaction.dart';

abstract class BankTransactionsManager {
  EmailContent emailContent;
  
  BankTransactionsManager(this.emailContent);
  
  bool isUPITransaction();
  bool isCreditCardTransaction();
  Transaction parseUPITransactionFromEmail();
  Transaction parseCreditCardTransactionFromEmail();
}
