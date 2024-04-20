import 'dart:convert';

import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/FileUtility.dart';
import 'package:email_credit_tracker/model/Transaction.dart';

class TransactionsManager {
  TransactionsManager._internal_constructor();

  static TransactionsManager? _instance;
  static TransactionsManager get instance {
    _instance ??= TransactionsManager._internal_constructor();
    return _instance!;
  }

  Map<String, Transaction> _allTransactions = {};
  String _TRANSACTIONS_WRITE_PATH = 'transactions_master.json';

  void loadTransactionsData() async {
    //For this we need a file util class that can write to file
    //Implement this
    bool fileExists = await FileUtil.fileExist(_TRANSACTIONS_WRITE_PATH);
    if (!fileExists) {
      return;
    }
    String transactionsJson = await FileUtil.readFile(_TRANSACTIONS_WRITE_PATH);
    _allTransactions = jsonDecode(transactionsJson);
  }

  void saveTransactionData() async {
    //For this we need a file util class that can write to file
    //Implement this data
    await FileUtil.writeToFile(
        _TRANSACTIONS_WRITE_PATH, jsonEncode(_allTransactions),
        forceCreate: true);
  }

  List<Transaction> getTransactionFiltered() {
    //Would be great if we can add some filtering mechanism : Would allow for better filtering
    //TODO : Implement aftet the transactions view is ready
    return _allTransactions.values.toList();
  }

  List<Transaction> getAllTransactions() {
    //Util method for the purposes of getting all transactoins
    return _allTransactions.values.toList();
  }

  int addTransactionToMasterList(Transaction transaction) {
    if (_allTransactions.containsKey(transaction.transactionId!)) {
      return Constants.STATUS_ERROR;
    }
    _allTransactions[transaction.transactionId!] = transaction;
    print("Added transaction " + transaction.toString());
    return Constants.STATUS_OK;
  }

  int updateTransactionInMasterList(
    Transaction transactionOrig, {
    int? amount,
    String? label,
    String? note,
    String? account,
    int? timestamp,
  }) {
    if (amount != null) {
      transactionOrig.amount = amount;
    }

    if (label != null) {
      transactionOrig.label = label;
    }

    if (note != null) {
      transactionOrig.note = note;
    }

    if (account != null) {
      transactionOrig.account = account;
    }

    if (timestamp != null) {
      transactionOrig.timestamp = timestamp;
    }

    return Constants.STATUS_OK;
  }
}
