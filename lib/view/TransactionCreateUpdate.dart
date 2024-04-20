import 'package:email_credit_tracker/model/Transaction.dart';
import 'package:email_credit_tracker/model/TransactionsManager.dart';
import 'package:email_credit_tracker/view/CommonWidgets/DottedButton.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [Form].

class CreateUpdateTransaction extends StatelessWidget {
  CreateUpdateTransaction({super.key, this.transaction});
  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  bool isCreateForm = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Transaction? transaction;

  _CreateUpdateFormState({this.transaction}) {
    this.isCreateForm = (transaction == null);
  }

  @override
  Widget build(BuildContext context) {
    int? amount;
    String account = "";
    String label = "";
    String note = "";
    DateTime? date;

    if (!isCreateForm) {
      amount = transaction!.amount!;
      account = transaction!.account!;
      label = transaction!.label!;
      note = transaction!.note!;
      date = DateTime.fromMillisecondsSinceEpoch(transaction!.timestamp!);
    }

    return Container(
      alignment: Alignment.bottomCenter,
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
              // decoration: const InputDecoration(
              //   hintStyle: TextStyle(color: Colors.black45),
              //   errorStyle: TextStyle(color: Colors.redAccent),
              //   border: OutlineInputBorder(),
              //   suffixIcon: Icon(Icons.event_note),
              //   labelText: 'Only time',
              // ),
              mode: DateTimeFieldPickerMode.time,
              initialDate: date,
              autovalidateMode: AutovalidateMode.always,
              validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
              onSaved: (newValue) => date = newValue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              // child: ElevatedButton(
              //   onPressed: () {
              //     // Validate will return true if the form is valid, or false if
              //     // the form is invalid.
              //     if (_formKey.currentState!.validate()) {}
              //   },
              //   child: const Text('Submit'),
              // ),
              child: DottedButton(
                text: 'Submit',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (isCreateForm) {
                      transaction = Transaction(amount, label, account, note,
                          date!.millisecondsSinceEpoch);
                      TransactionsManager.instance
                          .addTransactionToMasterList(transaction!);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
