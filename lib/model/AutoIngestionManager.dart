//I hate the name of this class!
//Still hate the name of this class
import 'dart:convert';

import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/FileUtility.dart';
import 'package:email_credit_tracker/model/BankTransactionsManager.dart';
import 'package:email_credit_tracker/model/EmailManager.dart';
import 'package:email_credit_tracker/model/HDFCTransactionManager.dart';
import 'package:email_credit_tracker/model/ICICITransactionsManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';

import 'EmailContent.dart';

class AutoIngestionManager {
  static AutoIngestionManager? _instance;
  static AutoIngestionManager get instance {
    _instance ??= AutoIngestionManager._internal_constructor();
    return _instance!;
  }

  AutoIngestionManager._internal_constructor();

  EmailManager? manager;

  final Map<String, CreditCardTransactionsManager> _emailToBanksCCManager = {
    "alerts@hdfcbank.net": HDFCCreditCardTransactionsManager(),
    "credit_cards@icicibank.com": ICICICreditCardTransactionsManager(),
  };

  final Map<String, UPITransactionsManager> _emailToBanksUPIManager = {
    "alerts@hdfcbank.net": HDFCUPITransactionManager(),
  };

  void debugWriteEmailContentRaw(
      EmailContent content, String nameOfFile) async {
    await FileUtil.writeToFile(
        nameOfFile, jsonEncode(content.toJson()).toString(),
        forceCreate: true);
    print("File exists ? $nameOfFile ${await FileUtil.fileExist(nameOfFile)}");
  }

  void addTransactionFromEmail(
      EmailContent email, Map<String, int> fileWrites) {
    if (!_emailToBanksCCManager.containsKey(email.from) &&
        !_emailToBanksUPIManager.containsKey(email.from)) {
      return;
    }
    print("Checking email from " + email!.from!);
    // debugWriteEmailContentRaw(
    //     email, email.from! + fileWrites[email.from!]!.toString());
    // print(email.emailTextRaw);

    Transaction? transaction;

    if (_emailToBanksCCManager.containsKey(email.from) &&
        _emailToBanksCCManager[email.from]!.isCreditCardTransaction(email)) {
      transaction = _emailToBanksCCManager[email.from]!
          .parseCreditCardTransactionFromEmail(email);
    } else if (_emailToBanksUPIManager.containsKey(email.from) &&
        _emailToBanksUPIManager[email.from]!.isUPITransaction(email)) {
      transaction = _emailToBanksUPIManager[email.from]!
          .parseUPITransactionFromEmail(email);
    }

    if (transaction == null) {
      return;
    }

    print("Adding transaction " + transaction.toString());

    int status =
        TransactionsManager.instance.addTransactionToMasterList(transaction!);
    if (status == Constants.STATUS_ERROR) {
      print("Error in Adding transaction " + transaction!.toString());
    }
  }

  void ingestTransactionsFromEmail() async {
    // ingestTransactionsFromFile();
    // return;
    if (manager == null) {
      throw Exception('Email Manager not set!');
    }
    Map<String, int> fileWrites = {};

    List<EmailContent> emails = await manager!.getUserMail();
    for (EmailContent email in emails) {
      if (!fileWrites.containsKey(email.from)) {
        fileWrites[email.from!] = 0;
      }

      addTransactionFromEmail(email, fileWrites);
      fileWrites[email.from!] = fileWrites[email.from!]! + 1;
    }
  }

  // void ingestTransactionsFromFile() async {
  //   List<String> filesToRead = [
  //     'alerts@hdfcbank.net0',
  //     'alerts@hdfcbank.net1',
  //   ];

  //   for (int i = 0; i < filesToRead.length; i++) {
  //     String name = filesToRead[i];
  //     String fileContent = await FileUtil.readFile(name);
  //     Map<String, dynamic> json = jsonDecode(fileContent);
  //     EmailContent email = EmailContent.fromJson(json);
  //     addTransactionFromEmail(email, {});
  //   }
  // }
}
