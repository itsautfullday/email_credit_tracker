import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'EmailContent.dart';

class HDFCUPITransactionManager extends UPITransactionsManager {
  HDFCUPITransactionManager() : super();

  bool isUPITransaction(EmailContent emailContent) {
    return false;
  }

  Transaction parseUPITransactionFromEmail(EmailContent emailContent) {
    return Transaction(0, "", "", "", 0);
  }
}

class HDFCCreditCardTransactionsManager extends CreditCardTransactionsManager {
  HDFCCreditCardTransactionsManager() : super();

  bool isCreditCardTransaction(EmailContent emailContent) {
    print(
        "Checking isCC ${emailContent.from == "alerts@hdfcbank.net"} ${emailContent.subject} ${emailContent.subject!.contains('Update on your HDFC Bank Credit Card')}");
    if (emailContent.from == "alerts@hdfcbank.net" &&
        emailContent.subject!
            .contains('Update on your HDFC Bank Credit Card')) {
      return true;
    }
    return false;
  }

  Transaction parseCreditCardTransactionFromEmail(EmailContent emailContent) {
    //Template for parsing : Thank you for using your HDFC Bank Credit Card ending 5834 for Rs 846.00 at GROFERS INDIA PRIVATE on 09-03-2024 21:22:00. Authorization code:- 097767
    printWrapped(emailContent.emailTextRaw!);
    return Transaction(0, "", "", "", 0);
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
