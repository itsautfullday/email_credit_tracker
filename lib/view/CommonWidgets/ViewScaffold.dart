import 'package:flutter/material.dart';

class ViewScaffold extends StatelessWidget {
  final Widget body;
  Widget? floatingActionButton;
  Widget? bottomNavigationBar;

  ViewScaffold(
      {super.key,
      required this.body,
      this.floatingActionButton,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text("Simple Transactions Manager",
            style: Theme.of(context).textTheme.bodyMedium),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
