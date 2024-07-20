import 'package:email_credit_tracker/Constants.dart';
import 'package:email_credit_tracker/model/ExpenseCategory.dart';
import 'package:email_credit_tracker/model/ExpenseCategoryManager.dart';
import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/view/CommonWidgets/DottedButton.dart';
import 'package:date_field/date_field.dart';
import 'package:email_credit_tracker/view/CommonWidgets/ViewScaffold.dart';
import 'package:flutter/material.dart';

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

//1. TODO : REFACTOR THIS FUCKING FILE
//2. Add delete button
//3. Fix how the drop down is coming out? Looks freaking weird
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
  ExpenseCategory initialCategory =
      ExpenseCategoryManager.instance.getCategory(Constants.UNDEFINED_CATEGORY);

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
    final Size size = MediaQuery.of(context).size;

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
        height: size.height * 0.8,
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

              SizedBox(
                width: 60,
                child: DropdownButtonFormField<ExpenseCategory>(
                  value: initialCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
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
                        alignment: Alignment.center,
                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          child: Image.asset(item!.assetPath!),
                        ));
                  }).toList(),
                ),
              ),

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
