import 'package:flutter/material.dart';

import '../model/AutoIngestionManager.dart';
import '../model/Transaction.dart';
import '../model/TransactionsManager.dart';
import '../view/TransactionCreateUpdate.dart';

class TransactionViewController extends ChangeNotifier {
  TransactionViewController._();
  static TransactionViewController? _instance;
  static TransactionViewController get instance {
    _instance ??= TransactionViewController._();
    return _instance!;
  }

  void updateTransactionsView() {
    notifyListeners();
  }

  bool shouldShowLoadingTransactionsMessage() {
    return !TransactionsManager.instance.getDataLoadCompleted();
  }

  bool shouldShowNoTransactionsMessage() {
    return TransactionsManager.instance.getDataLoadCompleted() &&
        TransactionsManager.instance.getAllTransactions().isEmpty;
  }

  List<Transaction> get updatedTransactions {
    return TransactionsManager.instance.getAllTransactions();
  }

  void refreshTransactionsFromEmail() async {
    await AutoIngestionManager.instance.ingestTransactionsFromEmail();
    notifyListeners();
  }

  void addTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateUpdateTransaction(transaction: null)),
    );
  }

  void editTransaction(BuildContext context, Transaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CreateUpdateTransaction(transaction: transaction)),
    );
  }
}
