import 'package:email_credit_tracker/controller/TransactionViewController.dart';

import '../model/Transaction.dart';
import '../model/TransactionsManager.dart';

class TransactionCreateUpdateController {
  void addTransaction(
      int amount, String label, String account, String note, DateTime date) {
    Transaction transaction =
        Transaction(amount, label, account, note, date!.millisecondsSinceEpoch);
    int code =
        TransactionsManager.instance.addTransactionToMasterList(transaction!);
    if (code == 0) {
      TransactionViewController.instance.updateTransactionsView();
    }
  }

  void updateTransaction(int? amount, String? label, String? account,
      String? note, DateTime? date, Transaction transaction) {
    try {
      if (amount != null) {
        transaction!.amount = amount;
      }

      if (account != null) {
        transaction!.account = account;
      }

      if (label != null) {
        transaction!.label = label;
      }

      if (note != null) {
        transaction!.note = note;
      }

      if (date != null) {
        transaction!.timestamp = date!.millisecondsSinceEpoch;
      }
    } catch (e, s) {
      print(s);
    }

    TransactionViewController.instance.updateTransactionsView();
  }
}
