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
    print(
        "Checking isUPI ${emailContent.from == "alerts@hdfcbank.net"} ${emailContent.subject} ${emailContent.subject!.contains('You have done a UPI txn')}");
    if (emailContent.from == "alerts@hdfcbank.net" &&
        emailContent.subject!.contains('You have done a UPI txn')) {
      return true;
    }
    return false;
  }

  Transaction parseUPITransactionFromEmail(EmailContent emailContent) {
    Document document = parse(emailContent.emailTextRaw!);
    Visitor _visitor = Visitor();
    _visitor.visit(document!.body!);

    //Sun, 17 Mar 2024 13:53:24 +0530
    DateFormat format = new DateFormat("E, dd MMM yyyy HH:mm:ss");
    DateTime dateTime = format.parse(emailContent.date!);

    print("Date Email : " + dateTime.toString());
    print(_visitor.result);

    RegExp vpaRegex = RegExp(r'VPA\s(.*?)(?=\d+\.\d{2}|on)');
    RegExp amountRegex = RegExp(r'Rs\.(\d+\.\d{2})');
    Match? vpaMatch = vpaRegex.firstMatch(emailContent.emailTextRaw!);
    Match? amountMatch = amountRegex.firstMatch(emailContent.emailTextRaw!);

    print(vpaMatch != null);
    print(amountMatch != null);
    if (vpaMatch != null && amountMatch != null) {
      String vpaString = vpaMatch.group(1)!;
      String amountString = amountMatch.group(1)!;

      double amount = double.parse(amountString);

      return Transaction(amount.toInt(), vpaString, "HDFC UPI Transaction", "",
          dateTime.millisecondsSinceEpoch);
    } else {
      print("No match found");
    }

    throw Exception("HDFC UPI unable to parse transaction");
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

  @override
  Transaction? parseCreditCardTransactionFromEmail(EmailContent emailContent) {
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

    double amount =
        double.parse(hdfc_data_clean[first_rs_index + 1].replaceAll(',', ''));

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
      return null;
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

    return Transaction(amount.toInt(), label, "HDFC Credit Card", "",
        dateTime.millisecondsSinceEpoch);
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
