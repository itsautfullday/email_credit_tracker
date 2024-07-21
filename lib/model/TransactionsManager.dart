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
    String transactionsJsonEncoded =
        await FileUtil.readFile(_TRANSACTIONS_WRITE_PATH);
    String transactionsJson = Uri.decodeFull(transactionsJsonEncoded);

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
        _TRANSACTIONS_WRITE_PATH, Uri.encodeFull(jsonEncode(_allTransactions)),
        forceCreate: true);
    print("File write complete" +
        FileUtil.fileExist(_TRANSACTIONS_WRITE_PATH).toString());
  }

  List<Transaction> getTransactionFiltered(
      bool Function(Transaction t) filter) {
    List<Transaction> result = [];
    _allTransactions.values.forEach((element) {
      if (filter(element)) {
        result.add(element);
      }
    });
    return result;
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
}
