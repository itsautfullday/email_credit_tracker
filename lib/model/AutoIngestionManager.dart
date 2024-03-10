//I hate the name of this class!
import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/EmailManager.dart';
import 'package:email_credit_tracker/model/HDFCTransactionManager.dart';
import 'package:email_credit_tracker/model/ICICITransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';

import 'EmailContent.dart';

class AutoIngestionManager {
  static AutoIngestionManager? _instance;
  static AutoIngestionManager get instance {
    _instance ??= AutoIngestionManager._internal_constructor();
    return _instance!;
  }

  AutoIngestionManager._internal_constructor();

  EmailManager? manager;

  final Map<String, CreditCardTransactionsManager> _emailToBanksCCManager = {
    "alerts@hdfcbank.net": HDFCCreditCardTransactionsManager(),
    "credit_cards@icicibank.com": ICICICreditCardTransactionsManager(),
  };

  final Map<String, UPITransactionsManager> _emailToBanksUPIManager = {
    "alerts@hdfcbank.net": HDFCUPITransactionManager(),
  };

  void ingestTransactionsFromEmail() async {
    if (manager == null) {
      throw Exception('Email Manager not set!');
    }

    List<EmailContent> emails = await manager!.getUserMail();
    for (EmailContent email in emails) {
      if (!_emailToBanksCCManager.containsKey(email.from) &&
          !_emailToBanksUPIManager.containsKey(email.from)) {
        continue;
      }

      Transaction? transaction;

      if (_emailToBanksCCManager.containsKey(email.from)) {
        print("Checking for cc " + email.from!);
        CreditCardTransactionsManager manager =
            _emailToBanksCCManager[email.from]!;
        if (manager.isCreditCardTransaction(email)) {
          transaction = manager.parseCreditCardTransactionFromEmail(email);
        }
      } else {
        UPITransactionsManager manager = _emailToBanksUPIManager[email.from]!;
        if (manager.isUPITransaction(email)) {
          transaction = manager.parseUPITransactionFromEmail(email);
        }
      }

      if (transaction == null) {
        continue;
      }

      int status =
          TransactionsManager.instance.addTransactionToMasterList(transaction!);
      if (status == Constants.STATUS_ERROR) {
        print("Error in Adding transaction " + transaction!.toString());
      }
    }
  }
}
