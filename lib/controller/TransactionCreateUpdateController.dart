import '../model/Transaction.dart';
import '../model/TransactionsManager.dart';

class TransactionCreateUpdateController {
  void addTransaction(
      int amount, String label, String account, String note, DateTime date) {
    Transaction transaction =
        Transaction(amount, label, account, note, date!.millisecondsSinceEpoch);
    TransactionsManager.instance.addTransactionToMasterList(transaction!);
  }

  void updateTransaction(int amount, String label, String account, String note,
      DateTime date, Transaction transaction) {
    transaction!.amount = amount;
    transaction!.account = account;
    transaction!.label = label;
    transaction!.note = note;
    transaction!.timestamp = date!.millisecondsSinceEpoch;
  }
}
