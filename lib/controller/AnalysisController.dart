import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:flutter/cupertino.dart';

class AnalysisController {
  AnalysisController._();

  static AnalysisController? _instance;
  static AnalysisController get instance {
    _instance ??= AnalysisController._();
    return _instance!;
  }

  AnalysisDateRangeChangeNotifier? current;

  DateTime _start = DateTime.now().subtract(Duration(days: 30));
  DateTime _end = DateTime.now();

  set start(DateTime val) {
    _start = val;
    current!.wrappedNotify();
  }

  DateTime get start {
    return _start;
  }

  set end(DateTime val) {
    _end = val;
    current!.wrappedNotify();
  }

  DateTime get end {
    return _end;
  }

  List<Transaction> getTransactionsWithinRange() {
    print("Calling getTransactionsWithinRange " +
        _start.toString() +
        " " +
        _end.toString());

    bool dateFilter(Transaction transaction) {
      DateTime timeStamp =
          DateTime.fromMillisecondsSinceEpoch(transaction.timestamp!);
      return (timeStamp.isBefore(_end!) && timeStamp.isAfter(_start));
    }

    List<Transaction> result =
        TransactionsManager.instance.getTransactionFiltered(dateFilter);
    return result;
  }
}

abstract class AnalysisTableFiller {
  String getAnalysisTitle();
  String getAnalysisKeys();
  Map<String, List<Transaction>> getUniqueKeysToTransactionMap();

  int getTotalSpend() {
    Map<String, int> uniqueKeysToTotals = getUniqueKeysToTotals();
    int total = 0;
    uniqueKeysToTotals.forEach((key, value) {
      total += value;
    });
    return total;
  }

  Map<String, int> getUniqueKeysToTotals() {
    Map<String, List<Transaction>> uniqueKeyToTransactions =
        getUniqueKeysToTransactionMap();
    Map<String, int> result = {};
    uniqueKeyToTransactions.forEach((key, value) {
      int keyTotal = 0;
      value.forEach((element) {
        keyTotal += element.amount!;
      });
      result[key] = keyTotal;
    });
    return result;
  }

  Map<String, double> getUniqueKeysToPercentageOfTotal() {
    Map<String, int> uniqueKeysToTotals = getUniqueKeysToTotals();
    int total = getTotalSpend();
    Map<String, double> result = {};
    uniqueKeysToTotals.forEach((key, value) {
      result[key] = (value / total) * 100;
    });

    return result;
  }
}

class AccountAnalysisTableFiller extends AnalysisTableFiller {
  @override
  Map<String, List<Transaction>> getUniqueKeysToTransactionMap() {
    List<Transaction> transactions =
        AnalysisController.instance.getTransactionsWithinRange();
    Map<String, List<Transaction>> result = {};
    transactions.forEach((element) {
      if (!result.containsKey(element.account)) {
        result[element.account!] = [];
      }
      result[element.account!]!.add(element);
    });
    return result;
  }

  @override
  String getAnalysisTitle() {
    return "Accounts Analysis";
  }

  @override
  String getAnalysisKeys() {
    return "Accounts";
  }
}

class CategoryAnalysis extends AnalysisTableFiller {
  @override
  Map<String, List<Transaction>> getUniqueKeysToTransactionMap() {
    List<Transaction> transactions =
        AnalysisController.instance.getTransactionsWithinRange();
    Map<String, List<Transaction>> result = {};
    transactions.forEach((element) {
      String key = ExpenseCategoryManager.instance
          .getCategory(element.category!)
          .categoryName!;

      if (!result.containsKey(key)) {
        result[key] = [];
      }
      result[key]!.add(element);
    });
    return result;
  }

  @override
  String getAnalysisTitle() {
    return "Category Analysis";
  }

  @override
  String getAnalysisKeys() {
    return "Categories";
  }
}

//create a singleton of this class
//this class's instance will be the instance that the consumer will listen to
//this class's instance will get its date change notification from the controller
class AnalysisDateRangeChangeNotifier extends ChangeNotifier {
  DateTime start = AnalysisController.instance.start;
  DateTime end = AnalysisController.instance.end;
  AnalysisDateRangeChangeNotifier() {
    AnalysisController.instance.current = this;
  }
  wrappedNotify() {
    notifyListeners();
  }
}
