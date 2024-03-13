import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'EmailContent.dart';
import 'HTMLParser.dart';

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
    Document document = parse(emailContent.emailTextRaw!);
    Visitor _visitor = Visitor();
    _visitor.visit(document!.body!);

    List<String> hdfc_data_unclean = _visitor.result.split(" ");
    List<String> hdfc_data_clean = [];
    hdfc_data_unclean.forEach((element) {
      if (element != '') {
        hdfc_data_clean.add(element);
      }
    });

    //The hdfc data is of the following template:
    // Dear Card Member,Thank
    // you for using your HDFC Bank Credit Card ending 1234
    // for Rs 1155.00 at PRESS TO on 07-03-2024 18:12:36.
    // Authorization code:- 034767After the above
    // transaction, the available balance on your card is
    // Rs 653374.00 and the total outstanding is Rs
    // 4626.00.For more details on this
    // transaction please visit HDFC Bank MyCards.If you have not done this transaction, please
    // immediately call on 18002586161 to report this
    int first_rs_index = hdfc_data_clean.indexOf('Rs');
    //Hence the next one is the value of transaction
    //Similarly the elements between at and on are elements to be joined by space for the purpose of label of transaction

    double amount = double.parse(hdfc_data_clean[first_rs_index + 1]);

    int atIndex = -1;
    int onIndex = -1;

    for (int i = first_rs_index; i < hdfc_data_clean.length; i++) {
      if (hdfc_data_clean[i] == 'at') {
        atIndex = i;
      }
      if (hdfc_data_clean[i] == 'on') {
        onIndex = i;
        break;
      }
    }

    if (atIndex == -1 || onIndex == -1) {
      print("Error $atIndex $onIndex");
      return Transaction(0, "", "", "", 0);
      ;
    }

    String label = "";

    for (int i = atIndex + 1; i < onIndex; i++) {
      label += "${hdfc_data_clean[i]} ";
    }
    print(label);
    print(amount);

    String timestampString =
        "${hdfc_data_clean[onIndex + 1]} ${hdfc_data_clean[onIndex + 2]}";

    DateFormat format = new DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime dateTime = format.parse(timestampString);

    return Transaction(amount.toInt(), label, "HDFC Credit Card", "", 0);
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
