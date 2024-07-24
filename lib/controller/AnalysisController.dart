import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/photoslibrary/v1.dart';

class AnalysisController {
  AnalysisDateRangeChangeNotifier dateRangeInstance =
      AnalysisDateRangeChangeNotifier.instance;
  AnalysisController._();

  static AnalysisController? _instance;
  static AnalysisController get instance {
    _instance ??= AnalysisController._();
    return _instance!;
  }

  DateTime start = AnalysisDateRangeChangeNotifier.instance.start;
  DateTime end = AnalysisDateRangeChangeNotifier.instance.end;

  List<Transaction> getTransactionsWithinRange() {
    bool dateFilter(Transaction transaction) {
      DateTime timeStamp =
          DateTime.fromMillisecondsSinceEpoch(transaction.timestamp!);
      return (timeStamp.isBefore(end!) && timeStamp.isAfter(start));
    }

    List<Transaction> result =
        TransactionsManager.instance.getTransactionFiltered(dateFilter);
    return result;
  }
}

abstract class AnalysisTableFiller {
  String getAnalysisTitle();
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
}

class CategoryAnalysis extends AnalysisTableFiller {
  @override
  Map<String, List<Transaction>> getUniqueKeysToTransactionMap() {
    List<Transaction> transactions =
        AnalysisController.instance.getTransactionsWithinRange();
    Map<String, List<Transaction>> result = {};
    transactions.forEach((element) {
      if (!result.containsKey(element.category)) {
        result[element.category!] = [];
      }
      result[element.category!]!.add(element);
    });
    return result;
  }

  @override
  String getAnalysisTitle() {
    return "Category Analysis";
  }
}

//create a singleton of this class
//this class's instance will be the instance that the consumer will listen to
//this class's instance will get its date change notification from the controller
class AnalysisDateRangeChangeNotifier extends ChangeNotifier {
  static AnalysisDateRangeChangeNotifier? _instance;
  static AnalysisDateRangeChangeNotifier get instance {
    _instance ??= AnalysisDateRangeChangeNotifier._();
    return _instance!;
  }

  AnalysisDateRangeChangeNotifier._();

  DateTime _start = DateTime.now().subtract(Duration(days: 30));
  DateTime _end = DateTime.now();

  DateTime get start {
    return _start;
  }

  DateTime get end {
    return _end;
  }

  set start(DateTime val) {
    _start = val;
    notifyListeners();
  }

  set end(DateTime val) {
    _end = val;
    notifyListeners();
  }
}
