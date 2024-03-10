import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'EmailContent.dart';

class ICICIUPITransactionManager extends UPITransactionsManager {

  ICICIUPITransactionManager():super();

  bool isUPITransaction(EmailContent emailContent) {
    return false;
  }

  bool isCreditCardTransaction(EmailContent emailContent) {
    if(emailContent.subject == 'Alert : Update on your ICICI Bank Credit Card'){
      return true;
    }
    return false;
  }

  Transaction parseUPITransactionFromEmail(EmailContent emailContent){
    return Transaction(0, "", "", "", 0);
  }
  
}

class ICICICreditCardTransactionsManager extends CreditCardTransactionsManager {

  ICICICreditCardTransactionsManager():super();

  bool isCreditCardTransaction(EmailContent emailContent) {
    if(emailContent.subject == 'Alert : Update on your ICICI Bank Credit Card'){
      return true;
    }
    return false;
  }


  Transaction parseCreditCardTransactionFromEmail(EmailContent emailContent){
    return Transaction(0, "", "", "", 0);
  }
}