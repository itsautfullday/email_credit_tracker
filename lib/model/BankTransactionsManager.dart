import 'package:email_credit_tracker/model/EmailContent.dart';
import 'package:email_credit_tracker/model/Transaction.dart';

abstract class UPITransactionsManager {
  bool isUPITransaction(EmailContent emailContent);
  Transaction? parseUPITransactionFromEmail(EmailContent emailContent);
}

abstract class CreditCardTransactionsManager {
  bool isCreditCardTransaction(EmailContent emailContent);
    Transaction? parseCreditCardTransactionFromEmail(EmailContent emailContent);
}
