import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'EmailContent.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'HTMLParser.dart';

class ICICIUPITransactionManager extends UPITransactionsManager {
  ICICIUPITransactionManager() : super();

  bool isUPITransaction(EmailContent emailContent) {
    return false;
  }

  bool isCreditCardTransaction(EmailContent emailContent) {
    if (emailContent.subject ==
        'Alert : Update on your ICICI Bank Credit Card') {
      return true;
    }
    return false;
  }

  Transaction parseUPITransactionFromEmail(EmailContent emailContent) {
    return Transaction(0, "", "", "", 0);
  }
}

class ICICICreditCardTransactionsManager extends CreditCardTransactionsManager {
  ICICICreditCardTransactionsManager() : super();

  bool isCreditCardTransaction(EmailContent emailContent) {
    print("${emailContent.from!} ${emailContent.subject!}");
    return emailContent.from == "credit_cards@icicibank.com" &&
        emailContent.subject!
            .contains('Transaction alert for your ICICI Bank Credit Card');
  }

  Transaction parseCreditCardTransactionFromEmail(EmailContent emailContent) {
    print("Printing ICICI Transaction");
    Document document = parse(emailContent.emailTextRaw!);
    Visitor _visitor = Visitor();
    _visitor.visit(document!.body!);
    List<String> docWords = _visitor.result.split(' ');
    print(docWords);

    int indexOf = docWords.indexOf('of');
    int indexTransactionAmount = indexOf += 2;

    int indexOn = docWords.indexOf('on');
    int indexAt = docWords.indexOf('at');

    int month = indexOn + 1;
    int date = month + 1;
    int year = date + 1;

    int indexTime = indexAt + 1;

    double amount = double.parse(docWords[indexTransactionAmount]);
    String transactionDateTimeString =
        "${docWords[year]}-${docWords[month]}-${docWords[date]} ${docWords[indexTime]}";

    print(transactionDateTimeString);
    DateFormat format = new DateFormat("yyyy-MMM-dd, HH:mm:ss.");
    DateTime dateTime = format.parse(transactionDateTimeString);
    print(dateTime.toString() + amount.toString());

    //Thanks chatgpt
    String result = _visitor.result;
    RegExp regex = RegExp(r'Info:\s(.*?)\.');

    Match? match = regex.firstMatch(result);

    if (match != null) {
      String extractedString = match.group(1)!;
      print("Extracted string: $extractedString");
      return Transaction(amount.toInt(), extractedString,
          "ICICI Credit card transaction", "", dateTime.millisecondsSinceEpoch);
    }

    throw Exception("ICIC : Could not find the String for label ");
  }
}
