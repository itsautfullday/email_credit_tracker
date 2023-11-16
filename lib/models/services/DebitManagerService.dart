import 'package:expense_manager_client_2/models/data_models/Debit.dart';

class DebitManagerService {
  Map<String, Debit> allDebits = {};

  void loadAllDebits(Map<String, Debit> allDebits) {
    allDebits = allDebits;
  }

  void addDebitToAllDebits(Debit newDebit) {
    if (allDebits.isNotEmpty && allDebits.containsKey(newDebit.debitId)) {
      throw Exception("DebitId already exists in log");
    }
    allDebits[newDebit.debitId] = newDebit;
  }

  void removeDebitFromList(String debitId) {
    if (allDebits.isEmpty) {
      throw Exception("All debits is empty");
    }

    if(allDebits.containsKey(debitId)){
      allDebits.remove(debitId);
    }
  }
}
