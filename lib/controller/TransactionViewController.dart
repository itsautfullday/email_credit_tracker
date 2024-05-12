import 'package:flutter/material.dart';

import '../model/Transaction.dart';
import '../model/TransactionsManager.dart';

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

  List<Transaction> get updatedTransactions  {
    return TransactionsManager.instance.getAllTransactions();
  }
}
