import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/model/ExpenseCategory.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:email_credit_tracker/view/CommonWidgets/DottedButton.dart';
import 'package:date_field/date_field.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/pagespeedonline/v5.dart';
import 'package:intl/intl.dart';

import '../controller/TransactionCreateUpdateController.dart';

/// Flutter code sample for [Form].
class CreateUpdateTransaction extends StatelessWidget {
  CreateUpdateTransaction({super.key, this.transaction});
  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
        body: Center(child: CreateUpdateForm(transaction: transaction)));
  }
}

class CreateUpdateForm extends StatefulWidget {
  CreateUpdateForm({super.key, this.transaction});
  final Transaction? transaction;

  @override
  State<CreateUpdateForm> createState() =>
      _CreateUpdateFormState(transaction: transaction);
}

class _CreateUpdateFormState extends State<CreateUpdateForm> {
  TransactionCreateUpdateController controller =
      TransactionCreateUpdateController();
  bool isCreateForm = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Transaction? transaction;
  ExpenseCategory initialCategory = ExpenseCategoryManager.instance
        .getCategory(Constants.UNDEFINED_CATEGORY);

  _CreateUpdateFormState({this.transaction}) {
    this.isCreateForm = (transaction == null);
  }

  @override
  Widget build(BuildContext context) {
    int? amount;
    String account = "";
    String label = "";
    String note = "";
    DateTime? date = DateTime.now();
    
    List<ExpenseCategory> categories =
        ExpenseCategoryManager.instance.getAllExpenseCategory();

    if (!isCreateForm) {
      amount = transaction!.amount!;
      account = transaction!.account!;
      label = transaction!.label!;
      note = transaction!.note!;
      date = DateTime.fromMillisecondsSinceEpoch(transaction!.timestamp!);
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height:
            500, // TODO UTKARSH Media query thia and do based off of percentage sitze of the screen
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                onSaved: (newValue) => amount = int.tryParse(newValue!)!,
                initialValue: amount == null ? null : amount!.toString(),
                style: Theme.of(context).textTheme.titleLarge,
                decoration: const InputDecoration(
                  hintText: 'Transaction amount',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: Theme.of(context).textTheme.titleLarge,
                onSaved: (newValue) => label = newValue!,
                initialValue: label,
                decoration: const InputDecoration(
                  hintText: 'Transaction label',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: Theme.of(context).textTheme.titleLarge,
                initialValue: account,
                onSaved: (newValue) => account = newValue!,
                decoration: const InputDecoration(
                  hintText: 'Transaction account',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                style: Theme.of(context).textTheme.titleLarge,
                initialValue: note,
                onSaved: (newValue) => note = newValue!,
                decoration: const InputDecoration(
                  hintText: 'Transaction note',
                ),
                validator: (String? value) {
                  return null;
                },
              ),
              //TODO : This breaks, allow for current time addition if not specified!
              DateTimeFormField(
                decoration: InputDecoration(
                  hintStyle: Theme.of(context).textTheme.titleLarge,
                  border: UnderlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                ),
                mode: DateTimeFieldPickerMode.dateAndTime,
                initialValue: date,
                initialDate: date,
                autovalidateMode: AutovalidateMode.always,
                validator: (DateTime? e) {
                  return null;
                },
                onSaved: (newValue) => date = newValue,
              ),
              DropdownButtonFormField<ExpenseCategory>(
                value: initialCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (ExpenseCategory? newValue) {
                  setState(() {
                    print("Calling set state " + newValue!.categoryId!);
                    initialCategory = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<ExpenseCategory>>(
                    (ExpenseCategory item) {
                  return DropdownMenuItem<ExpenseCategory>(
                    value: item,
                    child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        child: Image.asset(item!.assetPath!)),
                  );
                }).toList(),
              ),
              //TODO Use drop down form field for usage! https://www.dhiwise.com/post/user-selection-guide-to-flutter-dropdownbuttonformfield
              //

              //TODO Add delete button!

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DottedButton(
                  text: 'Save',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Validation passed");
                      _formKey.currentState!.save();
                      if (isCreateForm) {
                        controller.addTransaction(
                            amount!, label, account, note, date!);
                      } else {
                        print("Validation updated");
                        try {
                          controller.updateTransaction(amount!, label, account,
                              note, date, initialCategory, transaction!);
                        } catch (e, s) {
                          print(s);
                        }
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
