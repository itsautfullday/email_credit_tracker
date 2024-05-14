import 'dart:convert';

import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/FileUtility.dart';
import 'package:email_credit_tracker/model/Transaction.dart';

import '../controller/TransactionViewController.dart';

class TransactionsManager {
  TransactionsManager._internal_constructor();

  static TransactionsManager? _instance;
  static TransactionsManager get instance {
    _instance ??= TransactionsManager._internal_constructor();
    return _instance!;
  }

  bool _dataloadCompleted = false;

  bool getDataLoadCompleted() {
    return _dataloadCompleted;
  }

  Map<String, Transaction> _allTransactions = {};
  String _TRANSACTIONS_WRITE_PATH = 'transactions_master.json';

  Future<void> loadTransactionsData() async {
    //For this we need a file util class that can write to file
    //Implement this
    bool fileExists = await FileUtil.fileExist(_TRANSACTIONS_WRITE_PATH);
    if (!fileExists) {
      print("DATA LOADED : File does not exist");
      _dataloadCompleted = true;
      return;
    }
    String transactionsJson = await FileUtil.readFile(_TRANSACTIONS_WRITE_PATH);
    Map<String, dynamic> transactionsRaw = jsonDecode(transactionsJson);
    transactionsRaw.forEach(
        (key, value) => _allTransactions[key] = Transaction.fromJson(value));

    print("DATA LOADED : " + _allTransactions.length.toString());
    _dataloadCompleted = true;
    
  }

  Future<void> saveTransactionData() async {
    //For this we need a file util class that can write to file
    //Implement this data
    print("Starting file write");
    await FileUtil.writeToFile(
        _TRANSACTIONS_WRITE_PATH, jsonEncode(_allTransactions),
        forceCreate: true);
    print("File write complete" +
        FileUtil.fileExist(_TRANSACTIONS_WRITE_PATH).toString());
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
    return Constants.STATUS_OK;
  }

  void debugAddTransactions() {
    print("Calling debug add");
    Transaction transaction1 = Transaction(100, "smokes", "cash", "",
        (DateTime.now().subtract(Duration(days: 1))).millisecondsSinceEpoch);
    Transaction transaction2 = Transaction(100, "smokes", "cash", "",
        (DateTime.now().subtract(Duration(days: 1))).millisecondsSinceEpoch);
    Transaction transaction3 = Transaction(100, "smokes", "cash", "",
        (DateTime.now().subtract(Duration(days: 1))).millisecondsSinceEpoch);
    Transaction transaction4 = Transaction(100, "smokes", "cash", "",
        (DateTime.now().subtract(Duration(days: 1))).millisecondsSinceEpoch);
    TransactionsManager._instance!.addTransactionToMasterList(transaction1);
    TransactionsManager._instance!.addTransactionToMasterList(transaction2);
    TransactionsManager._instance!.addTransactionToMasterList(transaction3);
    TransactionsManager._instance!.addTransactionToMasterList(transaction4);
    print("End debug add");
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
